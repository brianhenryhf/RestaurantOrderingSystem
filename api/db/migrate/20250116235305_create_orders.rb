class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.datetime :order_date
      t.integer :total_in_cents

      t.timestamps
    end
  end
end
