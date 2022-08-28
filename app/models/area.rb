class Area < ApplicationRecord
  belongs_to :city

  has_one_attached :area_image
end
