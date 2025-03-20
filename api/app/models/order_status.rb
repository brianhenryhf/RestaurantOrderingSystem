# TODO NOTE: either an order has to only be saved when 'placed', or we need an 'incomplete' status, else
# some looser nullability check on status name here. an order with no status doesn't make sense. and a peristed order status
# entry with no status is definitely meaningless.
# for now, saving an order with no status implies incomplete. not ideal, but time is a factor...

# Model to represent statuses over time for order (actual 'status', the central thing held here, is a simple string).
# Proper function requires that OrderStatus rows are not updated by users - always append new rows for status updates.
# TODO improvement: include record of the user motivating status change
class OrderStatus < ApplicationRecord
  belongs_to :order
  validates :status, presence: true
  validates :status, allow_blank: true, inclusion: { in: StatusChangeRules.valid_statuses, message: "%{value} is not a valid status" }
  validate :allowed_status_transition

  scope :order_by_desc_recency, -> { order(updated_at: :desc) }

  #skippping enunm use for now - the generateed methods wil have no user-specific behavrios built in and its just mysterious and new
  # https://api.rubyonrails.org/v5.2.4.1/classes/ActiveRecord/Enum.html . int ordinals.

  def valid_for_user?(user)
    unless StatusChangeRules.new.allowed_next_for_user?(status, user)
      errors.add(:status, "#{status} is not allowed status for user type #{user.class}")
      return false
    end
    true
  end

  def allowed_status_transition
    prev_status = order.order_statuses.order_by_desc_recency.first&.status

    unless StatusChangeRules.new.allowed_next_for_current_status?(prev_status, status)
      errors.add(:status, "#{status} is not an allowed next status")
    end
  end
end
