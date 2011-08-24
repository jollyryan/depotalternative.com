class Specialty < ActiveRecord::Base
  has_many :suppliers

  before_validation :downcase_name
  validates_presence_of :name
  validates :name, :uniqueness => true
  

  private

  def downcase_name
    self.name = self.name.downcase if self.name.present?
  end

end
