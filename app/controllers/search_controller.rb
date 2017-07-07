class SearchController < ApplicationController

  before_action :authenticate_customer!

  def new
    # @tenders = Tender.all
  end

  def results
    @tenders = TenderWinner.search_results(params[:search], current_customer)
    # render :js => "$('.tenders_list').html('escape_javascript(<%= render :partial => 'tender_list' %>)');"
  end

end