class MessagesController < ApplicationController

  def index
    @messages = Message.where(receiver_id: current_company.id)
  end

  def show
    @message = Message.find(params[:id])
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
end