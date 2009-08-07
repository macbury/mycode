class CreateSnippets < ActiveRecord::Migration
  def self.up
    create_table :snippets do |t|
      t.text :code
      t.integer :uzytkownik_id
      t.integer :language
      t.integer :fork_id

      t.timestamps
    end
  end

  def self.down
    drop_table :snippets
  end
end
