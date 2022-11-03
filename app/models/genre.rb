class Genre < ApplicationRecord
  has_many :rel_shop_genre
  has_many :shop, through: :rel_shop_genre

  has_one_attached :image
end
