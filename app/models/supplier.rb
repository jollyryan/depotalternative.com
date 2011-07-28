class Supplier < ActiveRecord::Base
  belongs_to :city

  validates :name, :city_id, :presence => true
end
