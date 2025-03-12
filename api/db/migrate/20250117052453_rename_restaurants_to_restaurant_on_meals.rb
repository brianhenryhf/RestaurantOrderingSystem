class RenameRestaurantsToRestaurantOnMeals < ActiveRecord::Migration[7.1]
  def change
    remove_column :meals, :restaurants_id
    add_reference :meals, :restaurant, null: false, foreign_key: true
  end
end
