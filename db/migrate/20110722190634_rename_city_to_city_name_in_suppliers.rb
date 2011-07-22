class RenameCityToCityNameInSuppliers < ActiveRecord::Migration
  def self.up
    rename_column :suppliers, :city, :city_name
  end

  def self.down
    rename_column :suppliers, :city_name, :city
  end
end
