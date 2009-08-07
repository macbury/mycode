class AddKitsCountToTools < ActiveRecord::Migration
  def self.up
    add_column :tools, :kits_count, :integer, :default => 0
  end

  def self.down
    remove_column :tools, :kits_count
  end
end
