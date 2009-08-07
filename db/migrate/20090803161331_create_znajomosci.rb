class CreateZnajomosci < ActiveRecord::Migration
  def self.up
    create_table :znajomosci do |t|
      t.integer :uzytkownik_id
      t.integer :znajomy_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :znajomosci
  end
end
