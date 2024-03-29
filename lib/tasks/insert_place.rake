require_relative './google_place_api'
require_relative './kml_to_latlng'

# 奥州市市役所の緯度経度
LAT_LNG = KmlToLatLng.convert

BUSINESS_STATUS = { "OPERATIONAL": 1, "CLOSED_TEMPORARILY": 2, "CLOSED_PERMANENTLY": 3 }.freeze

TYPES = ['bakery', 'bar', 'cafe', 'food', 'meal_delivery', 'meal_takeaway', 'restaurant', 'shopping_mall'].freeze

namespace :insert_place do
  puts "+++++ Start Insert Place From Google Place API +++++"
  desc "奥州市役所から半径8kmのお店の情報をGooglePlaceAPIから取得し、DBにインサート"
  task :insert => :environment do
    google_place_id_ary = Shop.all.pluck(:google_place_id)
    tmp_shops = []
    LAT_LNG.each do |latlng|
      response_body = GooglePlaceApi.get_nearby_shop(latlng[:lat], latlng[:lng], 500, true)
      response_body.each do |res_ary, idx|
        res_ary.each_with_index do |(k, v), idx|
          res = res_ary.fetch("results", nil)
          next if res.blank?
          res.each do |ele|
            business_status = BUSINESS_STATUS.fetch(ele.fetch("business_status", nil).try(:to_sym), nil)
            google_place_id = ele.fetch("place_id", nil)
            lat = ele.fetch("geometry").fetch("location").fetch("lat")
            lng = ele.fetch("geometry").fetch("location").fetch("lng")
            name = ele.fetch("name", "")
            address = ele.fetch("vicinity", "")
            price_level = ele.fetch("price_level", nil)
            types = ele.fetch("types", nil)

            # すでに登録済みのお店はスキップ
            next if google_place_id_ary.include?(google_place_id)

            # typesが合わないものはスキップa
            next if (types & TYPES).size == 0

            # 同じオブジェクトを見つけ出し、重複していたらスキップ
            dup_shop_cnt = tmp_shops.map {|tmp| tmp.try(:google_place_id) }.count(google_place_id)
            next if dup_shop_cnt >= 1

            # 名前か住所が空であればスキップ
            next if name.empty? || address.empty?
            tmp_shops << Shop.new(
              name: name,
              latitude: lat,
              longitude: lng,
              address: address,
              business_status: business_status,
              price_level: price_level,
              google_place_id: google_place_id
            )
          end
        end
      end
    end
    Shop.import tmp_shops
    puts "++++++++++ 投入件数: #{tmp_shops.length} 件 ++++++++++"
    puts "+++++ Finish Insert Place From Google Place API +++++"
  end
end
