class CreateKits < ActiveRecord::Migration
  def self.up
    create_table :kits do |t|
      t.integer :uzytkownik_id
      t.integer :tool_id

      t.timestamps
    end
  end

  def self.down
    drop_table :kits
  end
end
