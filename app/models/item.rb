class Item < ActiveRecord::Base
  acts_as_taggable
  
  belongs_to :user
  has_many :comments
	has_many :stars, :dependent => :destroy

  attr_protected :user_id
  
  validates_length_of       :title, :within => 4..255
  validates_uniqueness_of   :name, :if => :name?
  validates_format_of       :name, :with => /^[\w\-\_]+$/, :if => :name?, :message => 'is invalid (alphanumerics, hyphens and underscores only)'
  validates_length_of       :name, :within => 4..255, :if => :name?
  validates_length_of       :content, :within => 25..1200
  
  def to_param
    self[:name] && self[:name].length > 3 ? self[:name] : self[:id]
  end

	def is_starred_by_user(user)
		user.starred_items.include? self
	end

  # TODO move to a helper
  def starred_class(user)
		if self.is_starred_by_user(user)
			return "starred"
		else
			return ""
		end
	end
end
