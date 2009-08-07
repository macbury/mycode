class RemoveColumnsFromStatuses < ActiveRecord::Migration
  def self.up
    remove_column :statuses, :statusable_type
    remove_column :statuses, :statusable_id
    remove_column :statuses, :icon
  end

  def self.down
  end
end
