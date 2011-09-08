class Favorite < ActiveRecord::Base
  belongs_to :user
  
  validates :supplier_id, :uniqueness => {:scope => :user_id} 
end
