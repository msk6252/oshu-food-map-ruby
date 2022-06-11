class Shop < ApplicationRecord
  include Discard::Model
  # include ActiveModel::Model
  # include ActiveModel::Attributes

  has_one_attached :inside_image
  has_one_attached :outside_image
  has_many_attached :cooking_images

  attr_accessor :current_distance
  #attribute :current_distance, :float, default: 0.0

  def distance_from_current(lat, lng)
    sql = <<-EOS
    select
      id,
      (6371 * ACOS(
        COS(RADIANS(#{lat})) * COS(RADIANS(s.latitude)) * cos(RADIANS(s.longitude) - RADIANS(#{lng}))
        + SIN(RADIANS(#{lat})) * SIN(RADIANS(s.latitude))
      )) as distance
    from
      shops s
    where
      id = #{id};
    EOS

    ActiveRecord::Base.connection.select_all(sql).to_hash
  end

  def self.distance_from_current_sortby(shops, lat, lng)
    return [] if shops.blank? || lat.blank? || lng.blank?

    distance_sortby = []

    shops.each do |shop|
      shop.current_distance = shop.distance_from_current(lat, lng).first["distance"]
    end

    shop_ary = shops.to_ary
    shop_ary.sort { |x, y| x.current_distance <=> y.current_distance }
  end
end
