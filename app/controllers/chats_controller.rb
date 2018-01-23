class ChatsController < ApplicationController
  before_action :authenticate_customer!

  def index
    render :layout => false
    @aa= "nnsdfsjdhf"
  end
end
