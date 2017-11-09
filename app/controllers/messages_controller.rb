class MessagesController < ApplicationController

 def index
  @messages = Message.where(receiver_id: current_customer.id)
 end

 def show

  @message = Message.find(params[:id])
 end

end