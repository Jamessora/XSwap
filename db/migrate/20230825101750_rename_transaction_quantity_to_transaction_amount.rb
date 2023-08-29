class RenameTransactionQuantityToTransactionAmount < ActiveRecord::Migration[7.0]
  def change
    rename_column :transactions, :transaction_quantity, :transaction_amount
  end
end
