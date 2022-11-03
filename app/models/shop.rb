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

  # enum public: { draft: 0, published: 1 }

  attr_accessor :current_distance
  #attribute :current_distance, :float, default: 0.0

  scope :active, -> { where(discarded_at: nil, public: true) }

  # 指定した位置情報から距離を出力
  def self.distance_from_current(lat, lng, shops)
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
      id in (#{shops.pluck(:id).join(",")});
    EOS

    ActiveRecord::Base.connection.select_all(sql).to_hash
  end

  # お店一覧を距離順にソート
  def self.distance_from_current_sortby(shops, lat, lng)
    return [] if shops.blank? || lat.blank? || lng.blank?

    shop_ary = []

    shop_distance_h = Shop.distance_from_current(lat, lng, shops)

    sort_shop_distance = shop_distance_h.sort { |x, y| x["distance"] <=> y["distance"] }

    sort_shop_distance.each do |d|
      shops.each do |shop|
        if shop.id == d["id"]
          shop.current_distance = d["distance"]
          shop_ary << shop
        end
      end
    end
    shop_ary
  end

  # 曜日ごとの営業時間を取得
  def group_business_hours
    dow = DayOfWeek.all
    self.business_hour.order(day_of_week: :asc).group_by(&:day_of_week).transform_keys!{|k| dow[k.to_s.to_sym]}
  end

  # お店が営業中かを判定
  def opening?
    return false if [2, 3].include?(self.business_status)
    current_time = Time.now
    bh = self.business_hour.where("? between started_at and finished_at", current_time)
    return bh.present? ? true : false
  end

  # お店の画像を1つの配列にする
  def image_list
    image_list = []
    return [] if blank?

    # 外装
    if outside_image.attached?
      image_list << outside_image
    end

    # 内装
    if inside_image.attached?
      image_list << inside_image
    end

    # 内装
    if cooking_images.attached?
      cooking_images.each do |img|
        image_list << img
      end
    end

    return image_list
  end
end
