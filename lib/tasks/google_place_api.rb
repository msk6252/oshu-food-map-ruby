require 'faraday'
require 'dotenv'
require 'faraday/net_http'
require 'json'

class GooglePlaceApi
  def self.get_nearby_shop(lat, lng, radius = 250, next_step = false)
    response_body = api_request(lat, lng, radius)
    response_ary = []
    return {} if response_body.empty?
    response_ary << response_body

    # 次のステップが不要であれば、そのまま返す
    return response_body if !next_step

    # ページネーションのtokenを取得
    next_page_token = response_body["next_page_token"]

    # next_page_tokenがあれば、繰り返し取得する
    # next_tokenが使えるようになるには、数秒かかるためsleepを用いる
    while !next_page_token.nil? && !next_page_token.empty? do
      sleep 5
      response_body = api_request(nil, nil, nil, next_page_token)

      response_ary << response_body

      next_page_token = response_body["next_page_token"]
    end

    return response_ary
  end

  def self.api_request(lat, lng, radius, next_page_token = '')
    Faraday.default_adapter = :net_http
    conn = Faraday.new(
      url: 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
    )

    types = ['cafe', 'food', 'meal_delivery', 'meal_takeaway', 'restaurant', 'shopping_mall']

    response = conn.get('/maps/api/place/nearbysearch/json') do |req|
      req.params['key'] = ENV['GOOGLE_MAP_API_KEY']
      req.headers['Content-Type'] = 'application/json'
      req.params['language'] = 'ja'
      req.params['location'] = "#{lat}, #{lng}"
      req.params['radius'] = radius
      req.params['types'] = types
      req.params['pagetoken'] = next_page_token if !next_page_token.empty?
    end

    return {} if response.body.empty?

    return JSON.parse(response.body).to_h
  end
end
