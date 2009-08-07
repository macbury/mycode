class AddNameToSnippets < ActiveRecord::Migration
  def self.up
    add_column :snippets, :name, :string
  end

  def self.down
    remove_column :snippets, :name
  end
end
