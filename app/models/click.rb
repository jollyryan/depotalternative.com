class Click < ActiveRecord::Base
  belongs_to :supplier

  scope :clicks_this_month, lambda { |d| { :conditions  => { :created_at  => d.beginning_of_month..d.end_of_month } } }

end
