class Znajomosc < ActiveRecord::Base
  belongs_to :uzytkownik
  belongs_to :znajomy, :class_name => "Uzytkownik"
end
