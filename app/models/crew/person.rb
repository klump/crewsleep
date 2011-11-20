class Crew::Person
  include Mongoid::Document
  include Mongoid::Timestamps

  field :firstname, :type => String
  field :lastname, :type => String
  field :nickname, :type => String
  field :canonical_nickname, :type => String
  field :avatar_url, :type => String
  field :cco_id, :type => Integer

  has_many :alarms, :class_name => "Sleep::Alarm"
  belongs_to :place, :class_name => "Sleep::Place"
  
  before_save do |obj|
    obj.canonical_nickname= nickname.downcase
  end
  
  def self.by_nick_or_ccoid(nick_or_ccoid)
      person = self.first(:conditions => { :cco_id => nick_or_ccoid })
      person = self.first(:conditions => { :canonical_nickname => nick_or_ccoid.downcase }) if person.nil?
      person = Crew::CcoService.fetch_person(nick_or_ccoid) if person.nil?
      return person if !person.nil?
  end
end