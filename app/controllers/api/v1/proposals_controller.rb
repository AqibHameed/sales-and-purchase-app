module Api
  module V1
    class ProposalsController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create, :negotiate]
      before_action :set_proposal, only: [ :negotiate, :show, :accept_and_decline ]
      before_action :verify_current_company, only: [ :negotiate, :show, :create, :accept_and_decline ]

      def create
        if current_company
          existing_proposal = Proposal.where(id: params[:id]).first
          if existing_proposal.present?
            existing_proposal.update_attributes(proposal_params)
            render json: { success: true, message: 'Proposal Updated Successfully' }
          else
            parcel = TradingParcel.where(id: params[:trading_parcel_id]).first      
            if parcel.present?
              proposal = Proposal.new(proposal_params)
              proposal.buyer_id = current_company.id
              proposal.seller_id = parcel.company_id
              proposal.notes = parcel.comment
              proposal.action_for = parcel.company_id
              proposal.buyer_comment = params[:comment]
              if proposal.save
                proposal.negotiations.create(price: proposal.price, percent: proposal.percent, credit: proposal.credit, total_value: proposal.total_value, comment: proposal.buyer_comment, from: 'buyer')
                CustomerMailer.send_proposal(proposal, current_customer, current_company.name).deliver rescue logger.info "Error sending email"
                Message.create_new(proposal)
                receiver_ids = proposal.seller.customers.map{|c| c.id}.uniq
                current_company.send_notification('New Proposal', receiver_ids)
                render json: { success: true, message: 'Proposal Submitted Successfully' }
              else
                render json: { success: false, errors: proposal.errors.full_messages }
              end
            else
              render json: { success: false, message: 'Parcel does not exists for this id.' }
            end
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def show
        get_proposal_details(@proposal)
        render :json => {:success => true, :proposal=> @data, response_code: 200 }
      end

      def accept_and_decline
        credit_limit = get_available_credit_limit(@proposal.buyer, current_company).to_f
        @company_group = CompaniesGroup.where("company_id like '%#{@proposal.buyer_id}%'").where(seller_id: current_company.id).first
        total_price = @proposal.price*@proposal.trading_parcel.weight
        if params[:perform] == 'accept'
          if current_company == @proposal.buyer
            @proposal.status = 1
            if @proposal.save(validate: false)
              accpet_proposal(@proposal)
              Message.buyer_accept_proposal(@proposal, current_company)
              render :json => {:success => true, :message=> ' Proposal is accepted. ', response_code: 201 }
            end
          else
            if params[:confirm] == 'true'
              accpet_proposal(@proposal)
              render :json => {:success => true, :message=> ' Proposal is accepted. ', response_code: 201 }
            else
              errors = get_errors_for_accept_or_negotiate(@proposal)
              if errors.present?
                render :json => { :success => false, :errors => errors }
              else
                accpet_proposal(@proposal)
                render :json => {:success => true, :message=> ' Proposal is accepted. ', response_code: 201 }
              end
            end
          end
        elsif params[:perform] == 'reject'
          @proposal.status = 2
          if @proposal.save(validate: false)
            render :json => {:success => true, :message=> ' Proposal is rejected. ', response_code: 201 }
          else
            render :json => {:success => false, :message=> ' Something went wrong. ', response_code: 201 }
          end
        else
          render :json => {:success => false, :message=> ' Appropriate action should be present. ', response_code: 201 }
        end      
      end

      def negotiate   
        if params[:negotiation_id].present?
          negotiation = Negotiation.where(id: params[:negotiation_id]).first
          render :json => {:success => false, :message=> 'Negotiation does not exists for the negotiation id.', response_code: 201 } and return unless negotiation
          render :json => {:success => false, :message=> 'This negotiation is not yours.', response_code: 201 } and return unless negotiation.whose == current_company
          if negotiation.proposal.negotiations.last == negotiation && negotiation.proposal.negotiated?
            if negotiation.update_attributes(negotiation_params)
              @proposal = negotiation.proposal
              update_parameters = {
                price: params[:price],
                percent: params[:percent],
                credit: params[:credit],
                total_value: params[:total_value]
              }
              (current_company == @proposal.buyer) ? update_parameters.merge({buyer_comment: params[:comment]}) : update_parameters.merge({notes: params[:comment]})
              @proposal.update_attributes(update_parameters)
              render :json => {:success => true, :message=> ' Negotiation is updated successfully. ', :negotiation => negotiation, response_code: 200 }  
            else
              render :json => {:success => false, :message=> 'Negotiation is not updated successfully.', response_code: 201 }
            end
          else
            render :json => {:success => false, :message=> 'It is proceeded, So Now you can not update it.', response_code: 201 }
          end
        else
          if !@proposal.negotiations.where(from: 'seller').present? && current_company == @proposal.seller
            if params[:confirm] == true
              update_proposal(@proposal)
            else
              errors = get_errors_for_accept_or_negotiate(@proposal)
              if errors.present?
                render :json => { :success => false, :errors => errors }
              else
                update_proposal(@proposal)
              end
            end
          else
            update_proposal(@proposal)
          end
        end        
      end

      def update_proposal(proposal)
        @proposal = proposal
        update_parameters = {
          price: params[:price],
          percent: params[:percent],
          credit: params[:credit],
          total_value: params[:total_value]
        }
        (current_company == @proposal.buyer) ? update_parameters.merge({buyer_comment: params[:comment]}) : update_parameters.merge({notes: params[:comment]})
        @proposal.update_attributes(update_parameters)
        who = (current_company == @proposal.buyer) ? 'buyer' : 'seller'
        last_negotiation = @proposal.negotiations.present? ? @proposal.negotiations.last : nil
        if last_negotiation.present? && last_negotiation.from == who && @proposal.negotiated?
          last_negotiation.update_attributes(negotiation_params)
          get_proposal_details(@proposal)
          render :json => {:success => true, :message=> ' Proposal is updated successfully. ', :proposal => @data, response_code: 200 }    
        else
          @proposal.negotiations.create((current_company == @proposal.buyer) ? negotiation_params.merge({from: 'buyer'}) : negotiation_params.merge({from: 'seller'})) 
          receiver =  (current_company == @proposal.buyer) ? @proposal.seller : @proposal.buyer
          receiver_emails = receiver.customers.map{ |c| c.email }
          CustomerMailer.send_negotiation(@proposal, receiver_emails, current_customer.email).deliver rescue logger.info "Error sending email"
          Message.create_new_negotiate(@proposal, current_company)
          receiver_ids = receiver.customers.map{ |c| c.id }.uniq
          current_company.send_notification('New Negotiation', receiver_ids)
          get_proposal_details(@proposal)
          render :json => {:success => true, :message=> ' Proposal is negotiated successfully. ', :proposal => @data, response_code: 200 }    
        end 
      end

      private

      def set_proposal
        @proposal = Proposal.where(id: params[:id]).first
        render :json => {:success => false, :message=> 'Proposal does not exists for this id.', response_code: 201 } and return unless @proposal
      end

      def proposal_params
        params.permit(:buyer_id, :seller_id, :credit, :price, :percent, :total_value, :trading_parcel_id)
      end

      def update_params
        params.permit(:price, :credit, :total_value, :percent)
      end

      def negotiation_params
        params.permit(:price, :credit, :total_value, :percent, :comment)
      end

      def verify_current_company
        render json: { errors: "Not authenticated", response_code: 201 } and return unless current_company
      end

      def get_errors_for_accept_or_negotiate(proposal)
        errors = []
        credit_limit = get_available_credit_limit(proposal.buyer, current_company).to_f
        available_market_limit  = get_available_credit_limit(proposal.buyer, current_company).to_f
        @company_group = CompaniesGroup.where("company_id like '%#{proposal.buyer_id}%'").where(seller_id: current_company.id).first
        if !params[:proposal].nil? && params[:proposal][:total_value].present?
          total_price =  params[:proposal][:total_value].to_f
        else
          total_price = proposal.price*proposal.trading_parcel.weight.to_f
        end
        if credit_limit < total_price.to_f
          limit = CreditLimit.where(buyer_id: proposal.buyer_id, seller_id: current_company.id).first
          if limit.nil?
            existing_limit = 0
            new_limit = total_price
          else
            existing_limit = limit.credit_limit
            new_limit = limit.credit_limit.to_f + total_price.to_f - credit_limit.to_f
          end 
          errors << "Your existing credit limit for this buyer was: #{number_to_currency(existing_limit)}. This transaction would increase it to #{number_to_currency(new_limit)}."
        end
        if @company_group.present? && (@company_group.group_market_limit < total_price)
          new_limit = @company_group.group_market_limit + (total_price - @company_group.group_market_limit)
          errors <<  "Your existing market_limit for this buyer group was: #{number_to_currency(@company_group.group_market_limit)}.  This transaction would increase it to #{ number_to_currency(new_limit)}"
        end
        market_limit = CreditLimit.where(buyer_id: proposal.buyer_id, seller_id: current_company.id).first
        if !@company_group.present? && available_market_limit.present? && available_market_limit < total_price.to_f
          if market_limit.nil?
            existing_market_limit = 0
            new_limit = total_price
          else 
            existing_market_limit = market_limit.market_limit
            new_limit = market_limit.market_limit.to_f + (total_price.to_f - available_market_limit.to_f)
          end
          errors << "Your existing market limit for this buyer was: #{ number_to_currency(existing_market_limit) }. This transaction would increase it to #{number_to_currency(new_limit) }"
        end
        if @company_group.present? && (check_for_group_overdue_limit(current_company, proposal.trading_parcel.company) || check_for_group_market_limit(current_company, proposal.trading_parcel.company))
          errors <<  "Buyer Group is currently a later payer and the number of days overdue exceeds your overdue limit."
        end
        if !@company_group.present? && (proposal.buyer.is_overdue || proposal.buyer.check_market_limit_overdue(get_market_limit(current_company, proposal.trading_parcel.try(:company_id)), proposal.trading_parcel.try(:company_id)))
          errors << "Buyer is currently later than your overdue days limit."
        end
        return errors
      end

      def get_proposal_details(proposal)        
        last_negotiation = proposal.negotiations.order('created_at ASC' ).last
        if proposal.buyer == current_company
          offered_last_negotiation = proposal.negotiations.where(from: 'seller').order('created_at ASC').last
        else
          offered_last_negotiation = proposal.negotiations.where(from: 'buyer').order('created_at ASC').last
        end
        if proposal.status == 'negotiated' 
          if proposal.negotiations.where(from: 'seller').present?
            status = "negotiated"
          else
            status = nil
          end
        else 
          status = proposal.status
        end
        @data = {
          status: status,
          supplier_name: proposal.seller.name,
          source: proposal.trading_parcel.present? ?  proposal.trading_parcel.source : 'N/A',
          description: proposal.trading_parcel.present? ? proposal.trading_parcel.description : 'N/A',
          sight: proposal.trading_parcel.present? ? proposal.trading_parcel.sight : 'N/A',
          no_of_stones: proposal.trading_parcel.present? ? proposal.trading_parcel.no_of_stones : 'N/A',
          carats: proposal.trading_parcel.present? ? proposal.trading_parcel.weight: 'N/A',
          cost: proposal.trading_parcel.present? ? proposal.trading_parcel.cost.to_f : 'N/A',
          list_percentage: proposal.trading_parcel.present? ? proposal.trading_parcel.percent.to_f : 'N/A',
          list_avg_price: proposal.trading_parcel.present? ? proposal.trading_parcel.price.to_f : 'N/A',
          list_total_price: proposal.trading_parcel.present? ? proposal.trading_parcel.total_value.to_f : 'N/A',
          list_credit: proposal.trading_parcel.present? ? proposal.trading_parcel.credit_period : 'N/A',
          list_discount: proposal.trading_parcel.present? ? proposal.trading_parcel.box_value.to_i : 'N/A',
          list_comment: proposal.trading_parcel.present? ? proposal.trading_parcel.comment : 'N/A'
        }
        if offered_last_negotiation.present?
          offered = {
            offered_percent: offered_last_negotiation.try(:percent).to_f,
            offered_price: offered_last_negotiation.try(:price).to_f,
            offered_credit: offered_last_negotiation.try(:credit).to_i,
            offered_total_value: offered_last_negotiation.try(:total_value).to_f,
            offered_comment: offered_last_negotiation.try(:comment)
          }
        else
          offered = {
            offered_percent: proposal.try(:percent).to_f,
            offered_price: proposal.try(:price).to_f,
            offered_credit: proposal.try(:credit).to_i,
            offered_total_value: proposal.try(:total_value).to_f,
            offered_comment: proposal.try(:comment)
          }
        end
        @data.merge!(offered)
        if proposal.negotiations.present? && proposal.status == 'negotiated'
          negotiated = {
            id: last_negotiation.try(:id),
            offered_percent: last_negotiation.try(:percent).to_f,
            offered_price: last_negotiation.try(:price).to_f,
            offered_total_value: last_negotiation.try(:total_value).to_f,
            offered_credit: last_negotiation.try(:credit),
            offered_comment: last_negotiation.try(:comment),
            offered_from: last_negotiation.try(:from) == 'seller' ? proposal.seller.name + '(seller)' : proposal.buyer.name + '(buyer)',
            is_mine: last_negotiation.whose == current_company
          }
          negotiations = []
          proposal.negotiations.each do |negotiation|
            negotiations << {
              id: negotiation.id,
              offered_percent: negotiation.percent.to_f,
              offered_credit: negotiation.credit,
              offered_price: negotiation.price.to_f,
              offered_total_value: negotiation.total_value.to_f,
              offered_comment: negotiation.comment,
              offered_from:  negotiation.from == 'seller' ? proposal.seller.name + '(seller)' : proposal.buyer.name + '(buyer)',
              is_mine: last_negotiation.whose == current_company
            }
          end
          @data.merge!(negotiated: negotiated)
          @data.merge!(total_negotiations: proposal.negotiations.count)
          @data.merge!(negotiations: negotiations)      
        else
          @data.merge!(negotiated: nil)
        end
      end

      def accpet_proposal(proposal)
        @proposal = proposal
        ActiveRecord::Base.transaction do
          @proposal.status = 1
          if @proposal.save(validate: false)  
            @available_credit_limit = get_available_credit_limit(@proposal.buyer, current_company).to_f
            @total_price = @proposal.price*@proposal.trading_parcel.weight
            available_market_limit = get_available_credit_limit(@proposal.buyer, current_company).to_f
            @group = CompaniesGroup.where("company_id like '%#{@proposal.buyer_id}%'").where(seller_id: current_company.id).first
            if @available_credit_limit < @total_price
              credit_limit = CreditLimit.where(buyer_id: @proposal.buyer_id, seller_id: current_company.id).first
              if credit_limit.nil?
                CreditLimit.create(buyer_id: @proposal.buyer_id, seller_id: current_company.id, credit_limit: @total_price, market_limit: @total_price)
              else
                @new_limit = credit_limit.credit_limit.to_f + @total_price.to_f  -  @available_credit_limit.to_f
                credit_limit.update_attributes(credit_limit: @new_limit)
              end
            end
            if @group.present? && @group.group_market_limit < @total_price
              new_limit = @group.group_market_limit + (@total_price - @group.group_market_limit)
              @group.update_attributes(group_market_limit: new_limit)
            end
            if !@group.present? && available_market_limit < @total_price
              market_limit = CreditLimit.where(buyer_id: @proposal.buyer_id, seller_id: current_company.id).first
              if market_limit.nil?
                CreditLimit.create(buyer_id: @proposal.buyer_id, seller_id: current_company.id, market_limit: @total_price)
              else
                new_limit = market_limit.market_limit.to_f + (@total_price.to_f - available_market_limit.to_f)
                market_limit.update_attributes(market_limit: new_limit)
              end
            end
            @proposal.trading_parcel.update_column(:sold, true)
            Transaction.create_new(@proposal)
          end
        end
      end
    end
  end
end