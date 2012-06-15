require "#{Rails.root}/lib/cco/service.rb"

class Crew::Person
  include Mongoid::Document
  include Mongoid::Timestamps

  field :firstname, :type => String
  field :lastname, :type => String
  field :username, :type => String
  field :avatar_url, :type => String
  field :cco_id, :type => Integer

  has_many :alarms, :class_name => "Sleep::Alarm"
  belongs_to :place, :class_name => "Sleep::Place"
  
  after_update do
    alarms.each do |alarm|
      alarm.update_person_and_place
      alarm.save
    end
  end
  
  def self.by_username_or_cco_id(username_or_cco_id)
    username_or_cco_id = UpcCode.new(username_or_cco_id).to_i if username_or_cco_id =~ /^\d{12}$/
    person = self.where(:username => /^#{username_or_cco_id}$/i).first
    person = self.where(:cco_id => username_or_cco_id.to_i).first unless person
    person = Cco::Service.fetch_person(username_or_cco_id) unless person
    person
  end
  
  alias_method :_avatar_url, :avatar_url
  def avatar_url
    a = _avatar_url
    a = "http://crew.dreamhack.se#{a}" unless a.nil? or a.start_with?("http")
    a
  end
end