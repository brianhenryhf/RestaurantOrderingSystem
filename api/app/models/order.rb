class Order < ApplicationRecord
  has_and_belongs_to_many :meals
  # accepts_nested_attributes_for :meals
  has_many :order_statuses

  #nice! - this will ensure customer, not owner class uses. also enforces presence.
  belongs_to :customer, foreign_key: 'user_id'
  belongs_to :restaurant

  # TODO unfortunate naming - fix to reflect timestamp, not date
  validates :order_date, presence: true
  validates :total_in_cents, presence: true

  before_validation :calc_total
  before_validation :ensure_order_date

  def current_status
    order_statuses.order_by_desc_recency.first
  end

  private

  def calc_total
    self.total_in_cents = meals.sum { |m| m.price_in_cents || 0 }
  end

  def ensure_order_date
    self.order_date ||= DateTime.current
  end
end
