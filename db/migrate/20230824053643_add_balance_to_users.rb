class AddBalanceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :balance, :decimal, precision: 15, scale: 10, default: 1000.00
  end
end
