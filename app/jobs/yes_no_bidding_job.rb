class YesNoBiddingJob<Struct.new(:tender)
	
	def perform
		if tender.present?
			@tender = Tender.find(tender)
			@yes_no_rounds = YesNoBuyerInterest.where(tender_id: @tender.id)
			@round_update = @yes_no_rounds.where(buyer_left: false)
			if @round_update.length > 2
				round_no = @yes_no_rounds.pluck(:round).sort_by(&:to_i)
				@yes_no_rounds.update_all(:round => round_no.last + 1)
			end
			@left_customers = @yes_no_rounds.where(interest: false).update_all(buyer_left: true)
			@going_for_next_round = @yes_no_rounds.where(interest: true)
			stop_dj = []
			if @tender.stones.present?
				@tender.stones.each_with_index do |stone,index|
			        if stone.present? && stone.yes_no_buyer_interests.where(buyer_left: false).length > 1
						total_customers = @tender.customers.length
						system_price,system_price_percentage = 0.0
						remaining_customers = stone.yes_no_buyer_interests.where(buyer_left: false).length
						left_customers = total_customers - remaining_customers
						reserved_price = stone.yes_no_system_price.present? ? stone.yes_no_system_price : stone.reserved_price - ((20.to_f/100.to_f)*stone.reserved_price)
						if reserved_price.to_f < stone.reserved_price.to_f
							system_price_percentage = remaining_customers.to_f/3.to_f*(1-left_customers.to_f/remaining_customers.to_f).to_f
							system_price = system_price_percentage.to_f/100.to_f*reserved_price.to_f
							@yes_no_system_price = reserved_price.to_f+system_price.to_f
						else
							system_price_percentage = remaining_customers.to_f/5.to_f*(1-left_customers.to_f/remaining_customers.to_f).to_f
							system_price = system_price_percentage.to_f/100.to_f*reserved_price.to_f
							@yes_no_system_price = reserved_price.to_f+system_price.to_f
							
						end
						stone.update_attributes(yes_no_system_price: @yes_no_system_price)
						time = Time.current + (@tender.rounds_between_duration.to_i).minutes
						bid_close = time + (@tender.round_duration.to_i).minutes
						@tender.update_attributes(bid_open: time, bid_close: bid_close)
						stone.yes_no_buyer_interests.where(buyer_left: false).update_all(interest: false, bid_open_time: time, bid_close_time: bid_close)
						stop_dj << false
			        elsif stone.present? && stone.yes_no_buyer_interests.where(buyer_left: false).length == 1
			        	winning_price = stone.yes_no_system_price.present? ? stone.yes_no_system_price : stone.reserved_price - ((20.to_f/100.to_f)*stone.reserved_price)
			          	stone.update_attributes(stone_winning_price: winning_price)
			            if !stone.yes_no_buyer_winner.present?
			          		winner = stone.yes_no_buyer_interests.where(buyer_left: false)
				        	winner = YesNoBuyerWinner.find_or_initialize_by(yes_no_buyer_interest_id: winner.first.id, tender_id: winner.first.tender_id, stone_id: winner.first.stone_id, sight_id: winner.first.sight_id, customer_id: winner.first.customer_id, bid_open_time: winner.first.bid_open_time, round: winner.first.round-1, winning_price: stone.yes_no_system_price, bid_close_time: winner.first.bid_close_time)
			          		winner.save
			          	end
			          	stop_dj << true
			        end
			    end 
			elsif @tender.sights.present?
			 	@tender.sights.each_with_index do |sight,index|
		        	if sight.present? && sight.yes_no_buyer_interests.where(buyer_left: false).length > 1
			            total_customers = @tender.customers.length
			            system_price,system_price_percentage = 0.0
			            remaining_customers = sight.yes_no_buyer_interests.where(buyer_left: false).length
			            left_customers = total_customers - remaining_customers
			            reserved_price = sight.yes_no_system_price.present? ? sight.yes_no_system_price : sight.sight_reserved_price.to_f - ((20.to_f/100.to_f)*sight.sight_reserved_price.to_f)
			            if reserved_price.to_f < sight.reserved_price.to_f
				            system_price_percentage = remaining_customers.to_f/5.to_f*(1-left_customers.to_f/remaining_customers.to_f).to_f
				            system_price = system_price_percentage.to_f/100.to_f*reserved_price.to_f
				            @yes_no_system_price = reserved_price.to_f+system_price.to_f
				        else    
				        	system_price_percentage = remaining_customers.to_f/5.to_f*(1-left_customers.to_f/remaining_customers.to_f).to_f
				            system_price = system_price_percentage.to_f/100.to_f*reserved_price.to_f
				            @yes_no_system_price = reserved_price.to_f+system_price.to_f
			            end
			            sight.update_attributes(yes_no_system_price: @yes_no_system_price)
			            time = Time.current + (@tender.rounds_between_duration.to_i).minutes
			            bid_close = time + (@tender.round_duration.to_i).minutes
			            @tender.update_attributes(bid_open: time, bid_close: bid_close)
			            sight.yes_no_buyer_interests.where(buyer_left: false).update_all(interest: false, bid_open_time: time, bid_close_time: bid_close)
			            stop_dj << false
			        elsif sight.present? && sight.yes_no_buyer_interests.where(buyer_left: false).length == 1
			        	winning_price = sight.yes_no_system_price.present? ? sight.yes_no_system_price : sight.sight_reserved_price.to_f - ((20.to_f/100.to_f)*sight.sight_reserved_price.to_f)
			            sight.update_attributes(stone_winning_price: winning_price)
			            if !sight.yes_no_buyer_winner.present?
				            winner = sight.yes_no_buyer_interests.where(buyer_left: false)
				            winner = YesNoBuyerWinner.find_or_initialize_by(yes_no_buyer_interest_id: winner.first.id, tender_id: winner.first.tender_id, sight_id: winner.first.sight_id, sight_id: winner.first.sight_id, customer_id: winner.first.customer_id, bid_open_time: winner.first.bid_open_time, round: winner.first.round-1, winning_price: sight.yes_no_system_price, bid_close_time: winner.first.bid_close_time)
				            winner.save
				        end 
				        stop_dj << true  
		          	end
		        end   
			end
	      	Delayed::Job.enqueue YesNoBiddingJob.new(@tender.id), 0, (@tender.bid_close) if !stop_dj.all? {|dj| dj == true}
	    end 
	end
	
	def max_attempts
    	3
  	end
end