class Crew::Person
  include Mongoid::Document
  include Mongoid::Timestamps

  field :firstname, :type => String
  field :lastname, :type => String
  field :nickname, :type => String
  field :avatar_url, :type => String
  field :cco_id, :type => Integer

  has_many :alarms, :class_name => "Sleep::Alarm"
  belongs_to :place, :class_name => "Sleep::Place"
  
  after_update do
    alarms.each &:save
  end
  
  alias_method :_avatar_url, :avatar_url
  def avatar_url
    a = _avatar_url
    a = "http://crew.dreamhack.se#{a}" unless a.nil? or a.start_with?("http")
    a
  end
end