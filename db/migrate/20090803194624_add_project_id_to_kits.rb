class AddProjectIdToKits < ActiveRecord::Migration
  def self.up
    add_column :kits, :project_id, :integer
  end

  def self.down
    remove_column :kits, :project_id
  end
end
