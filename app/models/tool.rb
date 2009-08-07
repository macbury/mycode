class Tool < ActiveRecord::Base
  xss_terminate
  has_many :kits, :dependent => :destroy
  has_many :projects, :through => :kits
  has_many :uzytkownicy, :through => :kits
  has_many :statuses, :as => :statusable, :dependent => :destroy
  
  validates_uniqueness_of :name
  validates_length_of :name, :within => 3..255
  validates_presence_of :name, :description, :url
  validates_length_of :description, :within => 3..500
  validates_length_of :url, :within => 3..255
  
  def self.languages(index=nil)
    lang = ['Ruby', 'Python', 'Sql', 'HTML', 'VB', 'C++', 'C#', 'CSS', 'Java', 'JavaScript', 'Pascal']
    
    if index
      return lang[index] rescue lang[0]
    else
      out = []
      lang.each_with_index do |l, index|
        out << [l, index]
      end
      return out
    end
  end
  
  def language_s
    if self.language.nil?
      return 'Brak'
    else
      Tool.languages(self.language)
    end
  end
  
  def type_s
    if self.typ.nil?
      return 'Brak'
    else
      Tool.typy(self.typ)
    end
  end
  
  def self.typy(index=nil)
    typy = ['Framework', 'Plugin', 'Biblioteka', 'Program']
    
    if index
      return typy[index] rescue typy[0]
    else
      out = []
      typy.each_with_index do |t, index|
        out << [t, index]
      end
      return out
    end
  end
  
  def own_by?(uzytkownik)
    !kits.find_by_uzytkownik_id(uzytkownik).nil?
  end

end
