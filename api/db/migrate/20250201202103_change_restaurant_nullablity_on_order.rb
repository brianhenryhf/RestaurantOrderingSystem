class ChangeRestaurantNullablityOnOrder < ActiveRecord::Migration[7.1]
  def change
    change_column_null :orders, :restaurant_id, false
  end
end
