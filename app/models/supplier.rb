class Supplier < ActiveRecord::Base
  attr_accessible :city_id, :specialty_id, :uploaded_file, :name, :description, :address, :phone_number, :email

  belongs_to :city
  belongs_to :specialty
  belongs_to :user

  validates :name, :city_id, :specialty_id, :presence => true

  #set up "uploaded_file" field as attached_file (using Paperclip)
  has_attached_file :uploaded_file,
                    :path => "suppliers/:id/:style/:basename.:extension",
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                    :bucket => "depotalternative",
                    :styles => {
                        :thumbnail => "150x150>",
                        :normal    => "800x800>"
                    }


  validates_attachment_size :uploaded_file, :less_than => 10.megabytes
  validates_attachment_presence :uploaded_file
  validates_attachment_content_type :uploaded_file, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  def file_name
    uploaded_file_file_name
  end

end
