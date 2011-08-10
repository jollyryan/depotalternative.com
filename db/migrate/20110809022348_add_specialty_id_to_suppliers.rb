class AddSpecialtyIdToSuppliers < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :specialty_id, :integer
  end

  def self.down
    remove_column :suppliers, :specialty_id
  end
end
