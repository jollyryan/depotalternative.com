class AddStateIdToSuppliers < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :state_id, :integer
  end

  def self.down
    remove_column :suppliers, :state_id
  end
end
