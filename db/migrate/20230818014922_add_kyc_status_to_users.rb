class AddKycStatusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :kyc_status, :string, default: 0 #default value is 0 which is 
  end
end
