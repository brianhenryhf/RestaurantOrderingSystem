class Restaurant < ApplicationRecord
  has_many :meals
  has_one :owner

  validates :name, presence: true
  validates :description, presence: true
end
