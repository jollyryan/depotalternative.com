class City < ActiveRecord::Base
  has_many :suppliers

  validates_presence_of :city_name
  validates_presence_of :state
end
