class CreateKycs < ActiveRecord::Migration[7.0]
 
  def change

    create_table :kycs do |t|
      t.string :fullName
      t.date :birthday
      t.string :address
      t.string :idType
      t.string :idNumber
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
