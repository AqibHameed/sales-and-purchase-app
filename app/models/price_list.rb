class PriceList

  require 'httparty'

  def self. get_data

    include HTTParty
    format :json

    url = "https://technet.rapaport.com/HTTP/JSON/Prices/GetPriceSheet.aspx"

    user =  '{
              "request": {
              "header": {
              "username": "73854",
              "password": "MehulMalini"
              },
                "body":{
              }
              }
              }'

    response = (post(url, :body => user , :options => { :headers => { 'ContentType' => 'application/x-www-form-urlencoded' } } ))
    op =  JSON.parse(response.body)

    # => structure
    # => price['size']['color']['clarity']
    #

    price = {}

    op['response']['body']['price'].each do |o|

      size = "#{o['low_size']}-#{o['high_size']}"
      shape = o['shape']

      price[shape] ||= {}
      price[shape][size] ||= {}
      price[shape][size][o['color']] ||= {}
      price[shape][size][o['color']][o['clarity']] = o['caratprice']

    end

    puts "=============================="
    puts price
    puts "=============================="

    $price = price

  end

end