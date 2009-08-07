class AddPolymorphicToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :statusable_type, :string
    add_column :statuses, :statusable_id, :integer
  end

  def self.down
  end
end
