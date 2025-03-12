class CreateJoinTableOrdersMeals < ActiveRecord::Migration[7.1]
  def change
    create_join_table :orders, :meals
  end
end
