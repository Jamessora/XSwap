class ChangeDefaultForKycStatusInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :kyc_status, nil
  end
end
