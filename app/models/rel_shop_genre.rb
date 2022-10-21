class RelShopGenre < ApplicationRecord
  belongs_to :shop
  belongs_to :genre

  scope :is_shop, -> (shop_id) { where(shop_id: shop_id) }
end
