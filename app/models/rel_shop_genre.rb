class RelShopGenre < ApplicationRecord
  belongs_to :shop
  belongs_to :genre
end
