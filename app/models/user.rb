class User < ActiveRecord::Base
  ROLES = %w[consumer supplier admin]
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role
  
  has_many :suppliers
  has_many :favorites,  :dependent => :destroy, :source => :supplier
  
  def admin?
    if self.role == "admin"
      true
    else
      false
    end
  end
  
  def location
    Geocoder.search(self.current_sign_in_ip)
  end
end
