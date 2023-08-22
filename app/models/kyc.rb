class Kyc < ApplicationRecord
  belongs_to :user
  validates :fullName, :birthday, :address, :idType, :idNumber, presence: true
end
