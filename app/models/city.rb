class City < ActiveRecord::Base
  has_many :suppliers
  belongs_to :state

  validates_presence_of :city_name
  validates_presence_of :state
end
