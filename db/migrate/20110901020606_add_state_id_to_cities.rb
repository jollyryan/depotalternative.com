class AddStateIdToCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :state_id, :integer
    remove_column :cities, :state
  end

  def self.down
    remove_column :cities, :state_id
    add_column :cities, :state, :string
  end
end
