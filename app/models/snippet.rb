class Snippet < ActiveRecord::Base
  has_many :statuses, :as => :statusable, :dependent => :destroy
  belongs_to :uzytkownik
  
  validates_length_of :name, :within => 3..255
  validates_presence_of :name, :code
  #validates_length_of :code, :within => 3..30_000
  
  xss_terminate :except => [:code]
  
  after_create :add_status
  
  def add_status
    uzytkownik.statuses.create( :message => "##{self.id}: dodaję nowy kawałek kodu" )
  end
  
  def code=(c)
    c.gsub!('<', '&lt;')
    c.gsub!('>', '&gt;')
    write_attribute :code, c
  end
  
  #def code
  #  c = read_attribute :code
  #  c.gsub!('&lt;', '<')
  #  c.gsub!('&gt;', '>')
    
  #  return c
  #end
  
  def language_s
    if self.language.nil?
      return 'RAW'
    else
      Tool.languages(self.language)
    end
  end
  
  def language_syntax
    language_s.downcase.to_sym
  end
end
