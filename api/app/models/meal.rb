class Meal < ApplicationRecord
  has_and_belongs_to_many :orders
  belongs_to :restaurant

  validates :name, presence: true
  validates :description, presence: true
  validates :price_in_cents, presence: true

end
