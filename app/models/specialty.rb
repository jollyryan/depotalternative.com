class Specialty < ActiveRecord::Base
  has_many :suppliers

  validates_presence_of :name

end
