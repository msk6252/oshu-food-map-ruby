class Area < ApplicationRecord
  belongs_to :city

  has_one_attached :image
end
