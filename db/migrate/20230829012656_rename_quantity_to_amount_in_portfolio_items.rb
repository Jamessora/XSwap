class RenameQuantityToAmountInPortfolioItems < ActiveRecord::Migration[7.0]
  def change
    rename_column :portfolio_items, :quantity, :amount
  end
end
