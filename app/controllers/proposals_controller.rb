class ProposalsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_proposal, only: [ :buyer_accept, :buyer_reject, :show, :edit, :delete, :update, :accept, :reject, :check_authenticate_person]
  before_action :check_authenticate_person, only: [:edit]

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include ApplicationHelper

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'Proposal not found'
    redirect_to trading_customers_path
  end

  def create
    @proposal = Proposal.new(proposal_params)
    # @proposal.check_sub_company_limit(current_customer)

    if @proposal.errors.any?
      flash[:notice] = @proposal.errors.full_messages.first
      redirect_to trading_parcel_path(id: params[:proposal][:trading_parcel_id])
    else
      if @proposal.save
        # Sent an email to supplier
        CustomerMailer.send_proposal(@proposal, current_customer, current_company.name).deliver rescue logger.info "Error sending email"
        Message.create_new(@proposal)
        receiver_ids = @proposal.seller.customers.map{|c| c.id}
        current_company.send_notification('New Proposal', receiver_ids)
        flash[:notice] = "Proposal sent to supplier."
        redirect_to trading_customers_path
      else
        error = @proposal.errors.full_messages.first
        flash[:notice] = error
        redirect_to trading_parcel_path(id: params[:proposal][:trading_parcel_id])
      end
    end
  end

  def index
    @proposals = Proposal.includes(:trading_parcel).where(status: 0).where(action_for: current_company.id).page params[:page]
  end

  def show
    @info = @proposal.trading_parcel.parcel_size_infos
    @proposal = Proposal.where(id: params[:id]).first
  end

  def edit
    @parcel = @proposal.trading_parcel
    @info = @proposal.trading_parcel.parcel_size_infos
  end

  def update
    if @proposal.update_attributes(proposal_params)
      # Email sent to action for column user
      receiver_emails = @proposal.seller.customers.map{|c| c.email}
      CustomerMailer.send_negotiation(@proposal, receiver_emails, current_customer.email).deliver rescue logger.info "Error sending email"
      Message.create_new_negotiate(@proposal, current_company)
      receiver_ids = @proposal.seller.customers.map{|c| c.id}
      current_company.send_notification('New Negotiation', receiver_ids)
      flash[:notice] = "Proposal sent successfully."
      redirect_to trading_customers_path
    else
      error = @proposal.errors.full_messages.first
      flash[:notice] = error
      redirect_to trading_customers_path
    end
  end

  def accept
    unless @proposal.status == 1
      if params[:check] == "true"
        check_credit_accept(@proposal)
      else
        accpet_proposal(@proposal)
        Message.accept_proposal(@proposal, current_company)
      end
    end
  end

  def reject
    @proposal.status = 2
    if @proposal.save(validate: false)
      flash[:notice] = "Proposal rejected"
      respond_to do |format|
        format.js { render js: "window.location = '/proposals'"}
        format.html { redirect_to trading_customers_path }
      end
      Message.reject_proposal(@proposal, current_company)
    end
  end

  def buyer_accept
    Message.buyer_accept_proposal(@proposal, current_company)
    redirect_to trading_customers_path
  end

  def buyer_reject
    Message.buyer_reject_proposal(@proposal, current_company)
    redirect_to trading_customers_path
  end

  def paid
    transaction = Transaction.find(params[:id])
    transaction.paid = true
    if transaction.save(validate: false)
      # transaction.release_credits
      flash[:notice] = "Status changed"
      respond_to do |format|
        format.js { render js: "window.location = '/suppliers/transactions'"}
        format.html { redirect_to transactions_suppliers_path }
      end
    end
  end

  def accpet_proposal(proposal)
    @proposal = proposal
    ActiveRecord::Base.transaction do
      @proposal.status = 1
      if @proposal.save(validate: false)
        available_credit_limit = get_available_credit_limit(@proposal.buyer, current_company).to_f
        available_market_limit = get_market_limit_from_credit_limit_table(@proposal.buyer, current_company)
        @group = CompaniesGroup.where("company_id like '%#{@proposal.buyer_id}%'").where(seller_id: current_company.id).first
        total_price = @proposal.price*@proposal.trading_parcel.weight
        if @group.present? && @group.group_market_limit < total_price
          new_limit = @group.group_market_limit + (total_price - @group.group_market_limit)
          @group.update_attributes(group_market_limit: new_limit)
        end
        if available_credit_limit < total_price
          credit_limit = CreditLimit.where(buyer_id: @proposal.buyer_id, seller_id: current_company.id).first
          if credit_limit.nil?
            CreditLimit.create(buyer_id: @proposal.buyer_id, seller_id: current_company.id, credit_limit: total_price)
          else
            new_limit = credit_limit.credit_limit + (total_price - available_credit_limit)
            credit_limit.update_attributes(credit_limit: new_limit)
          end
        end
        if !@group.present? && available_market_limit < total_price
          market_limit = CreditLimit.where(buyer_id: @proposal.buyer_id, seller_id: current_company.id).first
          if market_limit.nil?
            CreditLimit.create(buyer_id: @proposal.buyer_id, seller_id: current_company.id, market_limit: total_price)
          else
            new_limit = market_limit.market_limit + (total_price - available_market_limit)
            market_limit.update_attributes(market_limit: new_limit)
          end
        end
        @proposal.trading_parcel.update_column(:sold, true)
        Transaction.create_new(@proposal)
        # TradingParcel.send_won_parcel_email(@proposal)
        flash[:notice] = "Proposal accepted."
        respond_to do |format|
          format.js { render js: "window.location = '/customers/trading'"}
          format.html { redirect_to trading_customers_path }
        end
      end
      # @trading_parcel = @proposal.trading_parcel.dup
      # @trading_parcel.company_id = @proposal.buyer_id
      # @trading_parcel.sold = false
      # @trading_parcel.sale_all = false
      # @trading_parcel.save
    end
  end

  private
  def set_proposal
    @proposal = Proposal.find(params[:id])
  end

  def check_authenticate_person
    if @proposal.action_for == current_company.id
      # do nothing
    else
      flash[:notice] = "You have already sent proposal to other party."
      redirect_back fallback_location: trading_customers_path
    end
  end

  def check_credit_accept(proposal)
    errors = []
    credit_limit = get_available_credit_limit(proposal.buyer, current_company).to_f
    @company_group = CompaniesGroup.where("company_id like '%#{proposal.buyer_id}%'").where(seller_id: current_company.id).first
    total_price = proposal.price*proposal.trading_parcel.weight
    if credit_limit < total_price
      limit = CreditLimit.where(buyer_id: proposal.buyer_id, seller_id: current_company.id).first
      if limit.nil?
        new_limit = total_price
      else
        new_limit = limit.credit_limit + (total_price - credit_limit)
      end 
      errors << "Your existing credit limit for this buyer was: #{number_to_currency(credit_limit)}. This transaction would increase it to #{number_to_currency(new_limit)}."
    end
    if @company_group.present? && (@company_group.group_market_limit < total_price)
      new_limit = @company_group.group_market_limit + (total_price - @company_group.group_market_limit)
      errors <<  "Your existing market_limit for this buyer group was: #{number_to_currency(@company_group.group_market_limit)}.  This transaction would increase it to #{ number_to_currency(new_limit)}"
    end
    market_limit = CreditLimit.where(buyer_id: proposal.buyer_id, seller_id: current_company.id).first
    if !@company_group.present? && market_limit.present? && market_limit.market_limit < (proposal.price*proposal.trading_parcel.weight)
      available_market_limit = market_limit.market_limit
      total_price = proposal.price*proposal.trading_parcel.weight 
      if market_limit.nil?
        new_limit = total_price
      else 
        new_limit = market_limit.market_limit + (total_price - available_market_limit)
      end
      errors << "Your existing market limit for this buyer was: #{ number_to_currency(available_market_limit) }. This transaction would increase it to #{number_to_currency(new_limit) }"
    end
    if @company_group.present? && (check_for_group_overdue_limit(current_company, proposal.trading_parcel.company) || check_for_group_market_limit(current_company, proposal.trading_parcel.company))
      errors <<  "Buyer Group is currently a later payer and the number of days overdue exceeds your overdue limit."
    end
    if !@company_group.present? && (proposal.buyer.is_overdue || proposal.buyer.check_market_limit_overdue(get_market_limit(current_company, proposal.trading_parcel.try(:company_id)), proposal.trading_parcel.try(:company_id)))
      errors << "Buyer is currently a later payer and the number of days overdue exceeds your overdue limit."
    end
    if errors.present? 
      respond_to do |format|
        format.js { render 'proposals/credit_warning', locals: { proposal: proposal, available_credit_limit: credit_limit, errors: errors }}
      end
    else
      accpet_proposal(proposal)
    end
  end

  def proposal_params
    params.require(:proposal).permit(:buyer_comment, :buyer_id, :seller_id, :credit, :price, :action_for, :trading_parcel_id, :notes, :total_value, :percent)
  end
end
