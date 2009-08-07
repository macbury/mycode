class AddActivateToUzytkownik < ActiveRecord::Migration
  def self.up
    add_column :uzytkownicy, :active, :boolean, :default => false
  end

  def self.down
    remove_column :uzytkownicy, :active
  end
end
