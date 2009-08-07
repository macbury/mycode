class AddTypeToTools < ActiveRecord::Migration
  def self.up
    remove_column :tools, :language
    add_column :tools, :typ, :integer, :default => 0
    add_column :tools, :language, :integer, :default => nil
  end

  def self.down
    remove_column :tools, :typ
  end
end
