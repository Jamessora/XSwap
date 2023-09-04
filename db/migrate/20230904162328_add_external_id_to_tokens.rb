class AddExternalIdToTokens < ActiveRecord::Migration[7.0]
  def change
    add_column :tokens, :external_id, :string
    add_index :tokens, :external_id, unique: true
  end
end
