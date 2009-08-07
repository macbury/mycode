require 'gravtastic'
class Uzytkownik < ActiveRecord::Base
  include Gravtastic
  is_gravtastic!
  acts_as_authentic
  xss_terminate
  
  has_many :statuses, :dependent => :destroy
  has_many :kits, :dependent => :destroy
  has_many :tools, :through => :kits
  has_many :snippets, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  
  has_many :znajomosci, :dependent => :destroy
  has_many :znajomi, :through => :znajomosci
  
  after_create :add_status
  
  def to_param
    login
  end
  
  def active?
    active
  end
  
  def active!
    self.active = true
    save
  end
  
  def own?(object)
    object.uzytkownik_id == self.id
  end
  
  def deliver_activation
    reset_perishable_token!
    UzytkownikMailer.deliver_activate(self)
  end
  
  def addToKit(tool)
    kit = kits.find_or_create_by_tool_id(tool.id)
  end
  
  def add_status
    statuses.create :message => 'Właśnie zarejestrowałem się w serwisie!'
  end
  
  def obserwuje?(uzytkownik)
    !znajomosci.find_by_znajomy_id(uzytkownik.id).nil?
  end
end
