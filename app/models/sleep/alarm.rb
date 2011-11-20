class Sleep::Alarm
  include Mongoid::Document
  include Mongoid::Timestamps

  field :time, :type => DateTime
  field :poked, :type => Integer, :default => 0
  field :status, :type => Symbol, :default => :active

  belongs_to :place, :class_name => "Sleep::Place"
  belongs_to :person, :class_name => "Crew::Person"
end