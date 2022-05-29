require_relative './google_place_api'

# 奥州市市役所の緯度経度
LATITUDE  = 39.144434916042.freeze
LONGITUDE = 141.13920116004.freeze

BUSINESS_STATUS = { "OPEARIONAL": 1, "CLOSED_TEMPORARILY": 2, "CLOSED_PERMANENTLY": 3 }.freeze

namespace :insert_place do
  desc "奥州市役所から半径8kmのお店の情報をGooglePlaceAPIから取得し、DBにインサート"
  task :insert => :environment do
    tmp_shops = []
    response_body = GooglePlaceApi.get_nearby_shop(LATITUDE, LONGITUDE, 250, true)
    response_body.each_with_index do |res_ary, idx|
      # 最初の要素は奥州市に関するデータなので省く
      next if idx == 0
      res = res_ary["results"]

      # レスポンスデータがなければ返す
      next if res.blank?
       business_status = BUSINESS_STATUS.fetch(res["business_status"], nil)
       google_place_id = res.fetch("place_id", nil)
       price_level = res.fetch("price_level", nil)
       lat = res.fetch("geometry").fetch("location").fetch("lat")
       lng = res.fetch("geometry").fetch("location").fetch("lng")
       name = res.fetch("name", "")
       address = res.fetch("vicinity", "")

       # 名前が取得できないものに関しては、スキップ
       next if name.empty? || address.empty?
       tmp_shops << Shop.new(
         name: name,
         latitude: lat,
         longitude: lng,
         address: address,
         business_status: business_status,
         price_level: price_level,
         google_place_id: place_id
       )
    end
    Shop.import tmp_shops
  end
end
