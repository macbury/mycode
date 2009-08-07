class AddOdbiorcaIdToUzytkownik < ActiveRecord::Migration
  def self.up
    add_column :statuses, :odbiorca_id, :integer
  end

  def self.down
    remove_column :statuses, :odbiorca_id
  end
end
