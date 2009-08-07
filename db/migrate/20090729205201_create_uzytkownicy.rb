class CreateUzytkownicy < ActiveRecord::Migration
  def self.up
    create_table :uzytkownicy do |t|
      t.string    :login,               :null => false
      t.string    :email,               :null => false
      t.string    :crypted_password,    :null => false
      t.string    :password_salt,       :null => false
      t.string    :persistence_token,   :null => false
      t.string    :single_access_token, :null => false
      t.string    :perishable_token,    :null => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :uzytkownicy
  end
end
