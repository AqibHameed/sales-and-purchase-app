class CalculatorController < ApplicationController
  
  def index1
    PriceList.get_data if $price.nil?
    
    render :text => $price.inspect
    
  end
  
  
  def index
    PriceList.get_data if $price.nil?
    
  end

  def get_parcels
    @tender = Tender.find(params[:id])
  end

  def get_prices

    carat = params[:carat].to_f
    #@shape = params[:shape].downcase
    @shape = 'round'

    if (carat >= 0.0 and carat <= 0.03)
      @carat = '0.01-0.03'
    elsif (carat >= 0.04 and carat <= 0.07)
      @carat = '0.04-0.07'
    elsif (carat >= 0.08 and carat <= 0.14)
      @carat = '0.08-0.14'
    elsif (carat >= 0.15 and carat <= 0.17)
      @carat = '0.15-0.17'
    elsif (carat >= 0.18 and carat <= 0.22)
      @carat = '0.18-0.22'
    elsif (carat >= 0.23 and carat <= 0.29)
      @carat = '0.23-0.29'
    elsif (carat >= 0.30 and carat <= 0.39)
      @carat = '0.3-0.39'
    elsif (carat >= 0.40 and carat <= 0.49)
      @carat = '0.4-0.49'
    elsif (carat >= 0.50 and carat <= 0.69)
      @carat = '0.5-0.69'
    elsif (carat >= 0.70 and carat <= 0.89)
      @carat = '0.7-0.89'
    elsif (carat >= 0.90 and carat <= 0.99)
      @carat = '0.9-0.99'
    elsif (carat >= 1.0 and carat <= 1.49)
      @carat = '1.0-1.49'
    elsif (carat >= 1.50 and carat <= 1.99)
      @carat = '1.5-1.99'
    elsif (carat >= 2.00 and carat <= 2.99)
      @carat = '2.0-2.99'
    elsif (carat >= 3.00 and carat <= 3.99)
      @carat = '3.0-3.99'
    elsif (carat >= 4.00 and carat <= 4.99)
      @carat = '4.0-4.99'
    elsif (carat >= 5.0 and carat <= 5.99)
      @carat = '5.0-5.99'
    else
      @carat = '10.00-10.99'
    end
    

  end

end