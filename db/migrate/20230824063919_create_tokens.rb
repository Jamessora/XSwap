class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.string :ticker
      t.string :name
      t.decimal :price

      t.timestamps
    end
  end
end
