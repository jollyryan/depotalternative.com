class AddUserIdToSupplier < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :user_id, :integer
    add_index :suppliers, :user_id
  end

  def self.down
    remove_index :suppliers, :user_id
    remove_column :suppliers, :user_id
  end
end
