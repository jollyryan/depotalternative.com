class RemoveCityNameAndStateFromSuppliers < ActiveRecord::Migration
  def self.up
    remove_column :suppliers, :city_name
    remove_column :suppliers, :state
  end

  def self.down
    add_column :suppliers, :city_name, :string
    add_column :suppliers, :state, :string
  end
end
