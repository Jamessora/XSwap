class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one :kyc
  KYC_STATUSES = [nil, 'pending', 'approved', 'rejected']
  validates :kyc_status, inclusion: { in: KYC_STATUSES }, allow_nil: true
  devise :database_authenticatable, :registerable, :confirmable, #:recoverable, :rememberable, :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist
  
end
