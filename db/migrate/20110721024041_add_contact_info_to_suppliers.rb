class AddContactInfoToSuppliers < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :address, :string
    add_column :suppliers, :city, :string
    add_column :suppliers, :state, :string
    add_column :suppliers, :zip, :string
    add_column :suppliers, :phone_number, :string
    add_column :suppliers, :email, :string
  end

  def self.down
    remove_column :suppliers, :email
    remove_column :suppliers, :phone_number
    remove_column :suppliers, :zip
    remove_column :suppliers, :state
    remove_column :suppliers, :city
    remove_column :suppliers, :address
  end
end
