class AddRestaurantsToMeals < ActiveRecord::Migration[7.1]
  def change
    add_reference :meals, :restaurants, null: false, foreign_key: true
  end
end
