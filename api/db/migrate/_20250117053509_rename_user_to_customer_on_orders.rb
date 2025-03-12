
# remove? i think we don't want?
class RenameUserToCustomerOnOrders < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :user_id


    # problem! Order.create! customer: Customer.first, order_date: DateTime.current fails, b/c customers table is not real thing. customer_id
    # is not on orders table. but we don't actually want to allow any user to create an order, right? so how would sti handle
    # this - we want to be able to set customer on model. and have it map to users table, ideally with seom smarts to enforce a user _type_? or
    # i guess at least only allow a customer model to be set.

    # could try adding , :foreign_key 'user_id' to order model? and kill this migration, which won't work currntly
    # b/c fk can't be established to customer table, which is not a thing. can also change table name of ref here.
    # but not sure effects.

    add_reference :orders, :customer, null: false, foreign_key: true
  end
end
