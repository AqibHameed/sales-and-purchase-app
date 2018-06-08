class ProposalsController < ApplicationController
  # layout 'supplier'
  before_action :authenticate_customer!
  before_action :set_proposal, only: [ :show, :edit, :delete, :update, :accept, :reject, :check_authenticate_person ]
  before_action :check_authenticate_person, only: [:edit]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'Proposal not found'
    redirect_to trading_customers_path
  end

  def create
    @proposal = Proposal.new(proposal_params)
    @proposal.check_sub_company_limit(current_customer)

    if @proposal.errors.any?
        flash[:notice] = @proposal.errors.full_messages.first
        redirect_to trading_parcel_path(id: params[:proposal][:trading_parcel_id])
    else
      if @proposal.save
        # Sent an email to supplier
        Message.create_new_message(@proposal, current_customer)

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
    @proposals = Proposal.includes(:trading_parcel).where(status: 0).where(action_for: current_customer.id).page params[:page]
  end

  def show
    @info = @proposal.trading_parcel.parcel_size_infos
  end

  def edit
    @parcel = @proposal.trading_parcel
    @info = @proposal.trading_parcel.parcel_size_infos
  end

  def update
    if @proposal.update_attributes(proposal_params)
      # Email sent to action for column user
      Message.create_new_negotiate(@proposal, current_customer)
      flash[:notice] = "Proposal sent successfully."
      redirect_to trading_customers_path
    else
      error = @proposal.errors.full_messages.first
      flash[:notice] = error
      redirect_to trading_customers_path
    end
  end

  def accept
    ActiveRecord::Base.transaction do
      @proposal.status = 1
      if @proposal.save(validate: false)
        @proposal.trading_parcel.update_column(:sold, true)
        Transaction.create_new(@proposal)
        TradingParcel.send_won_parcel_email(@proposal)
        flash[:notice] = "Proposal accepted."
        respond_to do |format|
          format.js { render js: "window.location = '/proposals'"}
          format.html { redirect_to trading_customers_path }
        end
      end
      @trading_parcel = @proposal.trading_parcel.dup
      @trading_parcel.customer_id = @proposal.buyer_id
      @trading_parcel.sold = false
      @trading_parcel.sale_all = false
      @trading_parcel.save
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
    end
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

  private
  def set_proposal
    @proposal = Proposal.find(params[:id])
  end

  def check_authenticate_person
    if @proposal.action_for == current_customer.id
      # do nothing
    else
      flash[:notice] = "You have already sent proposal to other party."
      redirect_back fallback_location: trading_customers_path
    end
  end

  def proposal_params
    params.require(:proposal).permit(:buyer_id, :seller_id, :credit, :price, :action_for, :trading_parcel_id, :notes)
  end
end