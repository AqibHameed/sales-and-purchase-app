class ProposalsController < ApplicationController
  layout 'supplier'
  before_action :authenticate_customer!
  before_action :set_proposal, only: [ :show, :edit, :delete, :update, :accept, :reject, :check_authenticate_person ]
  before_action :check_authenticate_person, only: [:edit]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'Proposal not found'
    redirect_to trading_customers_path
  end

  def create
    @proposal = Proposal.new(proposal_params)
    if @proposal.save
      # Sent an email to supplier
      flash[:notice] = "Proposal sent to supplier."
      redirect_to trading_customers_path
    else
      error = @proposal.errors.full_messages.first
      flash[:notice] = error
      redirect_to trading_parcel_path(id: params[:proposal][:trading_parcel_id])
    end
  end

  def index
    @proposals = Proposal.includes(:trading_parcel).where(status: 0).where(action_for: current_customer.id).page params[:page]
  end

  def show
  end

  def edit
    @parcel = @proposal.trading_parcel
  end

  def update
    if @proposal.update_attributes(proposal_params)
      # Email sent to action for column user
      flash[:notice] = "Proposal sent successfully."
      redirect_to proposals_path
    else
      error = @proposal.errors.full_messages.first
      flash[:notice] = error
      redirect_to proposal_path(@proposal)
    end
  end

  def accept
    @proposal.status = 1
    if @proposal.save(validate: false)
    	@proposal.trading_parcel.update_column(:sold, true)
      Transaction.create_new(@proposal)
      flash[:notice] = "Proposal accepted."
      respond_to do |format|
        format.js { render js: "window.location = '/proposals'"}
        format.html { redirect_to proposals_path }
      end
    end
  end

  def reject
    @proposal.status = 2
    if @proposal.save(validate: false)
      flash[:notice] = "Proposal rejected"
      respond_to do |format|
        format.js { render js: "window.location = '/proposals'"}
        format.html { redirect_to proposals_path }
      end
    end
  end

  def paid
    transaction = Transaction.find(params[:id])
    transaction.paid = true
    if transaction.save
      flash[:notice] = "Status changed"
      respond_to do |format|
        format.js { render js: "window.location = '/suppliers/credit'"}
        format.html { redirect_to credit_suppliers_path }
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
      redirect_back fallback_location: root_path
    end
  end

  def proposal_params
    params.require(:proposal).permit(:buyer_id, :supplier_id, :credit, :price, :action_for, :trading_parcel_id, :notes)
  end
end