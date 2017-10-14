module Api
  module V1
    class TendersController <ApiController
      # before_action :current_customer
      skip_before_action :verify_authenticity_token, only: [:stone_parcel]

      def index
        col_str = ""
        upcoming_str = "open_date > '#{Time.zone.now}'"
        if params[:location] || params[:month] || params[:supplier]
          col_str =  "(lower(tenders.country) LIKE '%#{params[:location].downcase}%')"  unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.company_id =  #{params[:supplier]}" : " AND tenders.company_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        if current_customer
          active_tenders = current_customer.tenders.active.where(col_str).order("created_at desc")
          upcoming_tenders = current_customer.tenders.where(upcoming_str).where(col_str).order("created_at desc")
        else
          active_tenders = Tender.active.where(col_str).order("created_at desc")
          upcoming_tenders = Tender.where(upcoming_str).where(col_str).order("created_at desc")
        end
        tenders = active_tenders + upcoming_tenders
        render json: { tenders: tender_data(tenders), response_code: 200 }
      end

      def upcoming
        # col_str = "open_date > '#{Time.zone.now}'"
        # if params[:location] || params[:month] || params[:supplier]
        #   col_str =  "(tenders.country LIKE '%#{params[:location]}%')"  unless params[:location].blank?
        #   col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
        #   col_str += (col_str.blank?) ? "tenders.company_id =  #{params[:supplier]}" : " AND tenders.company_id = #{params[:supplier]}" unless params[:supplier].blank?
        # end
        # if current_customer
        #   tenders = current_customer.tenders.where(col_str).order("created_at desc")
        # else
        #   tenders = Tender.where(col_str).order("created_at desc")
        # end
        # render json: { success: true, tenders: tender_data(tenders), response_code: 200 }
        col_str = ""
        upcoming_str = "open_date > '#{Time.zone.now}'"
        if params[:location] || params[:month] || params[:supplier]
          col_str =  "(lower(tenders.country) LIKE '%#{params[:location].downcase}%')"  unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.company_id =  #{params[:supplier]}" : " AND tenders.company_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        if current_customer
          active_tenders = current_customer.tenders.active.where(col_str).order("created_at desc")
          upcoming_tenders = current_customer.tenders.where(upcoming_str).where(col_str).order("created_at desc")
        else
          active_tenders = Tender.active.where(col_str).order("created_at desc")
          upcoming_tenders = Tender.where(upcoming_str).where(col_str).order("created_at desc")
        end
        tenders = active_tenders + upcoming_tenders
        render json: { tenders: tender_data(tenders), response_code: 200 }
      end

      def closed
        col_str = "close_date < '#{Time.zone.now}'"
        if params[:location] || params[:month] || params[:supplier]
          col_str =  "(tenders.country LIKE '%#{params[:location]}%')"  unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.company_id =  #{params[:supplier]}" : " AND tenders.company_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        if current_customer
          tenders = current_customer.tenders.where(col_str).order("created_at desc")
        else
          tenders = Tender.where(col_str).order("created_at desc")
        end
        render json: { success: true, tenders: tender_data(tenders), response_code: 200 }
      end

      def tender_parcel
        stones = Stone.where(tender_id: params[:tender_id])
        render json: { success: true, tender_parcels: stone_data(stones), response_code: 200 }
      end

      def stone_parcel
        stone_parcel = Stone.where(id: params[:id]).first
        if stone_parcel.nil?
          errors = ['Parcel not found']
          render :json => { :errors => errors, response_code: 201 }
        else
          if stone_parcel.update(comments: params[:comments], valuation:  params[:valuation], parcel_rating:  params[:parcel_rating])
            render :json => { stone_parcel: stone_parcel, response_code: 200 }
          else
            render :json => {:errors => stone_parcel.errors.full_messages, response_code: 201 }
          end
        end
      end

      def find_active_parcels
        if params[:term].nil? || params[:term].blank?
          render json: { errors: "Invalid Parameters", response_code: 201 }
        else
          terms = params[:term].split(' ').map(&:to_f).delete_if{|i|i==0.0}
          @parcels = []
          begin
            terms.each do |term|
              @parcels << Stone.active_parcels(term)
            end
          rescue => e
            render json: { success: true, error: 'Something went wrong. Please try again with different image.', response_code: 201 }
          else
            render json: { success: true, parcels: active_parcel_data(@parcels.flatten), response_code: 200 }
          end 
        end
      end

      def tender_winners
        tender_winners = TenderWinner.where(tender_id: params[:tender_id])
        if tender_winners.empty?
          render json: { error: 'No winners for the tender', response_code: 201 }
        else
          render json: {tender_winners: tender_winners_data(tender_winners)}
        end
      end

      # def offline_data
      #   col_str = "open_date > '#{Time.zone.now}'"
      #   active_tenders = Tender.active
      #   upcoming_tenders =  Tender.where(col_str)
      #   tenders = active_tenders + upcoming_tenders
      #   render json: { tenders: offline_tender_data(tenders), response_code: 200 }
      # end

      def tender_data(tenders)
        @data = []
        if current_customer
          tenders.each do |tender|
            @data << {
              id: tender.id,
              name: tender.name,
              start_date: tender.open_date,
              end_date: tender.close_date,
              company_name: tender.company.try(:name),
              company_logo: nil,
              city: tender.city,
              country: tender.country,
              notification: tender.check_notification(current_customer),
              tender_parcels: stone_data(tender.stones)
            }
          end
          @data
        else
          tenders.each do |tender|
            @data << {
              id: tender.id,
              name: tender.name,
              start_date: tender.open_date,
              end_date: tender.close_date,
              company_name: tender.company.try(:name),
              company_logo: nil,
              city: tender.city,
              country: tender.country,
              notification: false,
              tender_parcels: stone_data(tender.stones)
            }
          end
          @data
        end
      end

      def stone_data(stones)
        @stones = []
        stones.each do |stone|
          @stones << {
            id: stone.id,
            stone_type: stone.stone_type,
            no_of_stones: stone.no_of_stones,
            :size => stone.size,
            :weight => stone.weight,
            :purity => stone.purity,
            :color => stone.color,
            :polished => stone.polished,
            :deec_no => stone.deec_no,
            :lot_no => stone.lot_no,
            :description => stone.description,
            :comments => stone.comments,
            :valuation => stone.valuation,
            :parcel_rating => stone.parcel_rating,
            :tender => stone.tender,
            :winners_data => []
            # historical_data(stone.try(:tender).try(:id), stone)
          }
        end
        @stones
      end

      def historical_data(id, stone)
        @w = []
        if stone.no_of_stones.to_i == 1
          # do nothing
        else
          desc = stone.description
          tender = current_customer.tenders.find(id) rescue Tender.find(id)
          tenders = Tender.includes(:tender_winners).where("id != ? and company_id = ? and date(close_date) < ?", tender.id, tender.company_id, tender.open_date.to_date).order("open_date DESC").limit(5)
          # winners = TenderWinner.includes(:tender).where("tender_id in (?) and tender_winners.description = ?", tenders.collect(&:id), desc)
          tender_winner_array = TenderWinner.includes(:tender).where(description: desc, tender_id: tenders.collect(&:id)).order("avg_selling_price desc").group_by { |t| t.tender.close_date.beginning_of_month }
          @winners = []
          tender_winner_array.each_pair do |tender_winner|
            @winners << tender_winner.try(:last).try(:first)
          end
          @winners = @winners.compact.sort_by{|e| e.tender.open_date}.reverse

          @winners.each do |winner|
            @w << {
              tender_id: winner.tender_id,
              lot_no: winner.lot_no,
              selling_price: winner.selling_price,
              created_at: winner.created_at,
              updated_at: winner.updated_at,
              description: winner.description,
              avg_selling_price: winner.avg_selling_price
            }
          end
        end
        @w
      end

      def active_parcel_data(stones)
        @stones = []
        duplicate_stones = stones.select{|item| stones.count(item) > 1}.uniq
        if duplicate_stones.empty?
          stones = stones
        else
          stones = duplicate_stones
        end
        stones.each do |stone|
          @stones << {
            id: stone.id,
            :description => stone.description,
            created_at: stone.created_at,
            updated_at: stone.updated_at,
            stone_type: stone.stone_type,
            no_of_stones: stone.no_of_stones,
            :size => stone.size,
            :weight => stone.weight,
            :purity => stone.purity,
            :color => stone.color,
            :polished => stone.polished,
            :deec_no => stone.deec_no,
            :lot_no => stone.lot_no,
            :comments => stone.comments,
            :valuation => stone.valuation,
            :parcel_rating => stone.parcel_rating,
            :tender_name => stone.name
          }
        end
        @stones
      end

      def tender_winners_data(tender_winners)
        winners = []
        tender_winners.each do |winner|
          stone = Stone.where(tender_id: winner.tender_id, lot_no: winner.lot_no).first
          winners << {
            description: winner.description,
            weight: stone.weight,
            comments: stone.comments,
            valuation: stone.valuation,
            parcel_rating: stone.parcel_rating,
            size: stone.size,
            weight: stone.weight,
            purity: stone.purity,
            color: stone.color,
            polished: stone.polished,
            deec_no: stone.deec_no,
            lot_no: stone.lot_no,
            selling_price: winner.selling_price,
            avg_selling_price: winner.avg_selling_price,
            tender_name: winner.tender.name,
            comments: stone.comments,
            valuation: stone.valuation,
            parcel_rating: stone.parcel_rating
          }
        end
        winners
      end

      # def offline_tender_data(tenders)
      #   @data = []
      #   if current_customer
      #     tenders.each do |tender|
      #       @data << {
      #         id: tender.id,
      #         name: tender.name,
      #         start_date: tender.open_date,
      #         end_date: tender.close_date,
      #         company_name: tender.company.try(:name),
      #         company_logo: nil,
      #         city: tender.city,
      #         country: tender.country,
      #         notification: tender.check_notification(current_customer),
      #         tender_parcels: offline_stone_data(tender.stones)
      #       }
      #     end
      #     @data
      #   else
      #     tenders.each do |tender|
      #       @data << {
      #         id: tender.id,
      #         name: tender.name,
      #         start_date: tender.open_date,
      #         end_date: tender.close_date,
      #         company_name: tender.company.try(:name),
      #         company_logo: nil,
      #         city: tender.city,
      #         country: tender.country,
      #         notification: false,
      #         tender_parcels: offline_stone_data(tender.stones)
      #       }
      #     end
      #     @data
      #   end
      # end

      # def offline_stone_data(stones)
      #   @stones = []
      #   stones.each do |stone|
      #     @stones << {
      #       id: stone.id,
      #       stone_type: stone.stone_type,
      #       no_of_stones: stone.no_of_stones,
      #       :size => stone.size,
      #       :weight => stone.weight,
      #       :purity => stone.purity,
      #       :color => stone.color,
      #       :polished => stone.polished,
      #       :deec_no => stone.deec_no,
      #       :lot_no => stone.lot_no,
      #       :description => stone.description,
      #       :comments => stone.comments,
      #       :valuation => stone.valuation,
      #       :parcel_rating => stone.parcel_rating,
      #       :winners_data => historical_data(stone.try(:tender).try(:id), stone)
      #     }
      #   end
      #   @stones
      # end
    end
  end
end