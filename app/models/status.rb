class Status < ActiveRecord::Base
  xss_terminate
  
  belongs_to :statusable, :polymorphic => true
  belongs_to :uzytkownik
  belongs_to :odbiorca, :class_name => "Uzytkownik"
  
  validates_presence_of :message
  validates_length_of :message, :within => 3..500
  
  def message=(message)
    
    #uzytkownicy
    if message =~ /^@(\w+)/i
      uzytkownik = Uzytkownik.find_by_login($1)
      message.gsub!(/^@(\w+)/i, '')
      self.odbiorca_id = uzytkownik.id unless uzytkownik.nil?
    end
    
    #projekt
    if message =~ /^&(.+):/i
      project = Project.find_by_name($1)
      message.gsub!(/^&(.+):/i, '')
      unless project.nil?
        self.statusable = project
        self.odbiorca_id = project.uzytkownik_id
      end
    end
    
    #snippety
    if message =~ /^#([0-9]+):/i
      snippet = Snippet.first(:conditions => { :id => $1 })
      message.gsub!(/^#([0-9]+):/i, '')
      unless snippet.nil?
        self.statusable = snippet
        self.odbiorca_id = snippet.uzytkownik_id
      end
    end
    
    #narzedzia
    if message =~ /^#(.+):/i
      tool = Tool.first(:conditions => { :name.like => $1 })
      message.gsub!(/^#(.+):/i, '')
      self.statusable = tool unless tool.nil?
    end
    
    write_attribute :message, message
  end
end
