class Shop < ApplicationRecord
  include Discard::Model
  # include ActiveModel::Model
  # include ActiveModel::Attributes

  # ジャンル
  has_many :rel_shop_genre
  has_many :genre, through: :rel_shop_genre

  # 営業時間
  has_many :business_hour

  has_one_attached :inside_image
  has_one_attached :outside_image
  has_many_attached :cooking_images

  enum public: { draft: 0, published: 1 }

  attr_accessor :current_distance
  #attribute :current_distance, :float, default: 0.0

  scope :active, -> { where(discarded_at: nil) }
  scope :published, -> { where(public: 1) }

  # 指定した位置情報から距離を出力
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

  # お店一覧を距離順にソート
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
