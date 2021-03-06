class ProposalsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_proposal, only: [:buyer_accept, :buyer_reject, :show, :edit, :delete, :update, :accept, :reject, :check_authenticate_person]
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
    if @proposal.save
      # Sent an email to supplier
      @proposal.negotiations.create(price: @proposal.price, percent: @proposal.percent, credit: @proposal.credit, total_value: @proposal.total_value, comment: @proposal.buyer_comment, from: 'buyer')
      CustomerMailer.send_proposal(@proposal, current_customer, current_company.name).deliver rescue logger.info "Error sending email"
      Message.create_new(@proposal)
      receiver_ids = @proposal.seller.customers.map {|c| c.id}
      current_company.send_notification('New Proposal', receiver_ids)
      flash[:notice] = "Proposal sent to supplier."
      redirect_to trading_customers_path
    else
      error = @proposal.errors.full_messages.first
      flash[:notice] = error
      redirect_to trading_parcel_path(id: params[:proposal][:trading_parcel_id])
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
    if !@proposal.negotiations.where(from: 'seller').present? && current_company == @proposal.seller
      if params[:flag] == "true"
        update_proposal(@proposal)
      else
        errors = get_errors_for_accept_or_negotiate(@proposal)
        if errors.present?
          check_credit_negotiate(@proposal, errors)
        else
          update_proposal(@proposal)
        end
      end
    else
      update_proposal(@proposal)
    end
  end

  def update_proposal(proposal)
    @proposal = proposal
    if @proposal.update_attributes(proposal_params)
      comment = (current_company == @proposal.buyer) ? @proposal.buyer_comment : @proposal.notes
      negotiation_params = {
          price: @proposal.price,
          percent: @proposal.percent,
          credit: @proposal.credit,
          total_value: @proposal.total_value,
          comment: comment
      }
      who = (current_company == @proposal.buyer) ? 'buyer' : 'seller'
      last_negotiation = @proposal.negotiations.present? ? @proposal.negotiations.last : nil
      if last_negotiation.present? && last_negotiation.from == who && @proposal.negotiated?
        last_negotiation.update_attributes(negotiation_params)
        flash[:notice] = "Proposal updated successfully."
      else
        @proposal.negotiations.create((current_company == @proposal.buyer) ? negotiation_params.merge({from: 'buyer'}) : negotiation_params.merge({from: 'seller'}))
        # Email sent to action for column user
        receiver = (current_company == @proposal.buyer) ? @proposal.seller : @proposal.buyer
        receiver_emails = receiver.customers.map {|c| c.email}
        CustomerMailer.send_negotiation(@proposal, receiver_emails, current_customer.email).deliver rescue logger.info "Error sending email"
        Message.create_new_negotiate(@proposal, current_company)
        receiver_ids = @proposal.seller.customers.map {|c| c.id}
        current_company.send_notification('New Negotiation', receiver_ids)
        flash[:notice] = "Proposal sent successfully."
      end
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
        Message.accept_proposal(@proposal, current_company)
        accpet_proposal(@proposal)
      end
    end
  end

  def reject
    @proposal.status = 2
    if @proposal.save(validate: false)
      flash[:notice] = "Proposal rejected"
      respond_to do |format|
        format.js {render js: "window.location = '/proposals'"}
        format.html {redirect_to trading_customers_path}
      end
      Message.reject_proposal(@proposal, current_company)
    end
  end

  def buyer_accept
    @proposal.status = 1
    if @proposal.save(validate: false)
      Message.buyer_accept_proposal(@proposal, current_company)
      accpet_proposal(@proposal)
    end
  end

  def buyer_reject
    @proposal.status = 2
    if @proposal.save(validate: false)
      flash[:notice] = "Proposal rejected"
      Message.buyer_reject_proposal(@proposal, current_company)
      redirect_to trading_customers_path
    end
  end

  def paid
    transaction = Transaction.find(params[:id])
    transaction.paid = true
    if transaction.save(validate: false)
      # transaction.release_credits
      flash[:notice] = "Status changed"
      respond_to do |format|
        format.js {render js: "window.location = '/suppliers/transactions'"}
        format.html {redirect_to transactions_suppliers_path}
      end
    end
  end

  def accpet_proposal(proposal)
    @proposal = proposal
    ActiveRecord::Base.transaction do
      @proposal.status = 1
      if @proposal.save(validate: false)
        available_credit_limit = get_available_credit_limit(@proposal.buyer, current_company).to_f
        available_market_limit = get_available_credit_limit(@proposal.buyer, current_company).to_f
        @group = CompaniesGroup.where("company_id like '%#{@proposal.buyer_id}%'").where(seller_id: current_company.id).first
        total_price = @proposal.price * @proposal.trading_parcel.weight
        if @group.present? && @group.group_market_limit < total_price
          new_limit = @group.group_market_limit + (total_price - @group.group_market_limit)
          @group.update_attributes(group_market_limit: new_limit)
        end
        if available_credit_limit < total_price
          credit_limit = CreditLimit.where(buyer_id: @proposal.buyer_id, seller_id: current_company.id).first
          if credit_limit.nil?
            CreditLimit.create(buyer_id: @proposal.buyer_id, seller_id: current_company.id, credit_limit: total_price, market_limit: total_price)
          else
            new_limit = credit_limit.credit_limit.to_f + total_price.to_f - available_credit_limit.to_f
            credit_limit.update_attributes(credit_limit: new_limit)
          end
        end
        if !@group.present? && available_market_limit < total_price
          market_limit = CreditLimit.where(buyer_id: @proposal.buyer_id, seller_id: current_company.id).first
          if market_limit.nil?
            CreditLimit.create(buyer_id: @proposal.buyer_id, seller_id: current_company.id, market_limit: total_price)
          else
            new_limit = market_limit.market_limit.to_f + (total_price.to_f - available_market_limit.to_f)
            market_limit.update_attributes(market_limit: new_limit)
          end
        end
        @proposal.trading_parcel.update_column(:sold, true)
        Transaction.create_new(@proposal)
        # TradingParcel.send_won_parcel_email(@proposal)
        flash[:notice] = "Proposal accepted."
        respond_to do |format|
          format.js {render js: "window.location = '/customers/trading'"}
          format.html {redirect_to trading_customers_path}
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
    errors = get_errors_for_accept_or_negotiate(proposal)
    if errors.present?
      respond_to do |format|
        format.js {render 'proposals/credit_warning', locals: {proposal: proposal, errors: errors, flag: false}}
      end
    else
      accpet_proposal(proposal)
    end
  end

  def check_credit_negotiate(proposal, errors)
    if errors.present?
      respond_to do |format|
        format.js {render 'proposals/credit_warning', locals: {proposal: proposal, errors: errors, flag: true}}
      end
    end
  end

  def get_errors_for_accept_or_negotiate(proposal)
    errors = []
    credit_limit = get_available_credit_limit(proposal.buyer, current_company).to_f
    available_market_limit = get_available_credit_limit(proposal.buyer, current_company).to_f
    @company_group = CompaniesGroup.where("company_id like '%#{proposal.buyer_id}%'").where(seller_id: current_company.id).first
    if !params[:proposal].nil? && params[:proposal][:total_value].present?
      total_price = params[:proposal][:total_value].to_f
    else
      total_price = proposal.price * proposal.trading_parcel.weight.to_f
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
      errors << "Your existing market_limit for this buyer group was: #{number_to_currency(@company_group.group_market_limit)}.  This transaction would increase it to #{ number_to_currency(new_limit)}"
    end
    market_limit = CreditLimit.where(buyer_id: proposal.buyer_id, seller_id: current_company.id).first
    if !@company_group.present? && available_market_limit.present? && available_market_limit < total_price.to_f
      if market_limit.nil?
        existing_market_limit = 0
        new_limit = total_price
      else
        existing_market_limit = market_limit.market_limit.to_f
        new_limit = market_limit.market_limit.to_f + (total_price.to_f - available_market_limit.to_f)
      end
      errors << "Your existing market limit for this buyer was: #{ number_to_currency(existing_market_limit) }. This transaction would increase it to #{number_to_currency(new_limit) }"
    end
    if @company_group.present? && (check_for_group_overdue_limit(current_company, proposal.trading_parcel.company) || check_for_group_market_limit(current_company, proposal.trading_parcel.company))
      errors << "Buyer Group is currently a later payer and the number of days overdue exceeds your overdue limit."
    end
    if !@company_group.present? && (proposal.buyer.is_overdue || proposal.buyer.check_market_limit_overdue(get_market_limit(current_company, proposal.trading_parcel.try(:company_id)), proposal.trading_parcel.try(:company_id)))
      errors << "Buyer is currently later than your overdue days limit."
    end
    return errors
  end

  def proposal_params
    params.require(:proposal).permit(:buyer_comment, :buyer_id, :seller_id, :credit, :price, :action_for, :trading_parcel_id, :notes, :total_value, :percent)
  end
end
