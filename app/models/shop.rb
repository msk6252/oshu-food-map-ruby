class Shop < ApplicationRecord
  include Discard::Model

  has_one_attached :inside_image
  has_one_attached :outside_image
  has_many_attached :cooking_images

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
end
