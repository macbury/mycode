class CreateTools < ActiveRecord::Migration
  def self.up
    create_table :tools do |t|
      t.string :name
      t.string :language, :default => nil
      t.string :description, :limit => 500
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :tools
  end
end
