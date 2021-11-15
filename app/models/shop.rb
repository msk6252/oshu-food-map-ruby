class Shop < ApplicationRecord
  include Discard::Model

  has_one_attached :inside_image
  has_one_attached :outside_image
  has_many_attached :cooking_images
end
