class Project < ActiveRecord::Base
  has_many :statuses, :as => :statusable, :dependent => :destroy
  has_many :kits, :dependent => :destroy
  has_many :tools, :through => :kits
  belongs_to :uzytkownik
  
  has_attached_file :preview, :styles => { :medium => "320x240>", :thumb => "24x24>" }
  validates_attachment_size :preview, :less_than => 1.megabyte
  validates_attachment_content_type :preview, :content_type => ['image/jpeg', 'image/png']
  
  xss_terminate
  
  validates_presence_of :name, :description
  validates_length_of :name, :within => 3..255
  validates_length_of :description, :within => 3..500
  validates_format_of :url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix, :if => :not_blank_url?
  
  validates_associated :tools
  
  attr_accessor :used_tools
  before_save :build_tools
  after_create :add_status
  
  def not_blank_url?
    !(url.nil? || url.blank?)
  end
  
  def add_status
    statuses.create :message => 'Dodaje nowy projekt', :uzytkownik_id => self.uzytkownik_id
  end
  
  def used_tools
    self.tools
  end
  
  def build_tools
    self.kits.each(&:destroy)
    self.kits = []
    
    Tool.all(:conditions => { :id.in => @used_tools.map(&:to_i) }).each do |tool|
      self.kits.build(:tool_id => tool.id, :uzytkownik => self.uzytkownik)
    end
  end
end
