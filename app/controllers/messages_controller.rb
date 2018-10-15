class MessagesController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_message
  before_action :check_authenticate_receiver, only: [:show]

  def index
    @messages = []
    all_messages = Message.joins(:sender).order("companies.name").where(receiver_id: current_company.id)
    all_messages.group_by(&:proposal_id).each do |proposal_id, messages|
      @messages << messages.last
    end
  end

  def show
  end

  def new
    @message = Message.new
    @company = Company.find(params[:id])
  end

  def create
    @message = Message.new(message_params)
    @message.sender_id = current_company.id

    if @message.save
      redirect_to trading_customers_path, notice: "Message is successfully send"
    end
  end

  private
    def message_params
      params.require(:message).permit(:subject, :message, :message_type, :receiver_id)
    end

    def set_message
      @message = Message.find_by(id: params[:id])
    end

    def check_authenticate_receiver
      if current_company.try(:id) == @message.try(:receiver_id)
      else
        flash[:notice] = 'You are not authorized for this action'
        redirect_to trading_customers_path
      end
    end

end