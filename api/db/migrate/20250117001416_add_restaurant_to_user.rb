class AddRestaurantToUser < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :restaurant, null: false, foreign_key: true
  end
end
