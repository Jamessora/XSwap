class AddUsdValueToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :usd_value, :float
  end
end
