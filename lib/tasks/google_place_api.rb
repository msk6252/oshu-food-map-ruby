require 'faraday'
require 'dotenv'
require 'faraday/net_http'

class GooglePlaceApi
  def self.get_nearby_shop(lat, lng)
    Faraday.default_adapter = :net_http
    conn = Faraday.new(
      url: 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
    )

    types = ['cafe', 'food', 'meal_delivery', 'meal_takeaway', 'restaurant', 'shopping_mall']

    response = conn.get('/maps/api/place/nearbysearch/json') do |req|
      req.params['location'] = "#{lat}, #{lng}"
      req.params['radius'] = '8000'
      req.params['types'] = types
      req.params['language'] = 'ja'
<<<<<<< HEAD
      req.params['key'] = ''
=======
      req.params['key'] = ENV['GOOGLE_MAP_API_KEY']
>>>>>>> develop
      req.headers['Content-Type'] = 'application/json'
    end
  
    puts response.body
  end
end

GooglePlaceApi.get_nearby_shop(43.0888026, 141.3414549)
