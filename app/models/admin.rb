class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, #:recoverable, :rememberable, :validatable, 
          :jwt_authenticatable,
          jwt_revocation_strategy: JwtDenylist  
end
