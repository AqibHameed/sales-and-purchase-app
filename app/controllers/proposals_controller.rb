class ProposalsController < ApplicationController
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
    else
      error = @proposal.errors.first.full_messages
      flash[:notice] = error
    end
    redirect_to trading_customers_path
  end

  def index
    @proposals = Proposal.includes(:trading_parcel).where.not(status: 1).where(action_for: current_customer.id)
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
    else
      error = @proposal.errors.first.full_messages
      flash[:notice] = error
    end
    redirect_to proposals_path
  end

  def accept
    if params[:accept] == "true"
      @proposal.status = 1
      @proposal.save
      flash[:notice] = "Proposal accepted."
    end
    respond_to do |format|
      format.js { render js: "window.location = '/proposals'"}
      format.html { redirect_to proposals_path }
    end
  end

  def reject
    if params[:reject] == "true"
      @proposal.status = 2
      @proposal.save
      flash[:notice] = "Proposal rejected."
    end
    respond_to do |format|
      format.js { render js: "window.location = '/proposals'"}
      format.html { redirect_to proposals_path }
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
      flash[:notice] == "You have already sent proposal to other party."
      redirect_to :back
    end
  end

  def proposal_params
    params.require(:proposal).permit(:buyer_id, :supplier_id, :credit, :price, :action_for, :trading_parcel_id, :notes)
  end
end