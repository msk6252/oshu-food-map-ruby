require 'faraday'
require 'faraday/net_http'

class GooglePlaceApi
  def self.get_nearby_shop(lat, lng)
    Faraday.default_adapter = :net_http
    conn = Faraday.new(
      url: 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
    )
  
    response = conn.get('/maps/api/place/nearbysearch/json') do |req|
      req.params['location'] = "#{lat}, #{lng}"
      req.params['radius'] = '250'
      req.params['types'] = 'food'
      req.params['language'] = 'ja'
      req.params['key'] = ''
      req.headers['Content-Type'] = 'application/json'
    end
  
    puts response.body
  end
end

GooglePlaceApi.get_nearby_shop(43.0888026, 141.3414549)
