class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :message, :limit => 500
      t.string :statusable_type
      t.integer :statusable_id
      t.integer :uzytkownik_id
      t.integer :icon

      t.timestamps
    end
  end

  def self.down
    drop_table :statuses
  end
end
