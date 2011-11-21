class Sleep::Alarm
  include Mongoid::Document
  include Mongoid::Timestamps

  field :time, :type => DateTime
  field :poked, :type => Integer, :default => 0
  field :status, :type => Symbol, :default => :active

  # belongs_to :place, :class_name => "Sleep::Place"
  belongs_to :person, :class_name => "Crew::Person"
  
  field :section_name, :type => String
  field :person_name, :type => String
  field :place_string, :type => String
  
  before_save do |obj|
    obj.section_name = obj.person.place.section.name
    obj.person_name = obj.person.username
    obj.place_string = obj.person.place.to_s
  end
  
  def self.active_grouped_by_time_and_section
    alarms = self.where(:status => :active).order_by([:section_name, :asc])
    
    times = {}
    
    alarms.each do |alarm|
      times[alarm.time] ||= {alarm.section_name => []}
      (times[alarm.time][alarm.section_name] ||= []) << {
        :name => alarm.person_name,
        :place => alarm.place_string,
        :pokes => alarm.poked
      }
    end
    
    times = times.keys.map do |time|
      sections = times[time].keys.map do |section|
        {
          :name => section,
          :items => times[time][section]
        }
      end
      { 
        :time => time.strftime("%A %H:%M"),
        :sections => sections
      }
    end
    
    # [{
    #   :time => 'Mon 13:30,
    #   :sections=>[
    #       :name=>"Main",
    #       :items=>[]
    #     ]
    # }]
    
    times.to_a.sort do |a,b|
      a[:time] <=> b[:time]
    end
  end
end