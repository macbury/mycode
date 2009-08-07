class Kit < ActiveRecord::Base
  belongs_to :tool, :counter_cache => true
  belongs_to :uzytkownik
  belongs_to :project
  #after_create :add_status
  #before_destroy :remove_status
  
  def add_status
    uzytkownik.statuses.create( :message => "dodaje &#{self.tool.name} do swojej listy narzędzi" )
  end

  def remove_status
    uzytkownik.statuses.create( :message => "usuwa &#{self.tool.name} z swojej listy narzędzi" )
  end
end
