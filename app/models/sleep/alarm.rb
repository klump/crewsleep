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
  field :person_image_url, :type => String
  
  before_save do |obj|
    obj.section_name = obj.person.place.section.name
    obj.person_name = obj.person.username
    obj.place_string = obj.person.place.to_s
    obj.person_image_url = obj.person.avatar_url
  end
  
  scope :active, where(:status => :active)
  
  def self.active_poked
    self.where(:status => :active, :poked.gt => 0)
  end
  
  def self.active_grouped_by_time_and_section
    alarms = self.where(:status => :active, :time.lt => (Time.now + 2.hours)).order_by([[:time, :asc],[:section_name, :asc]]).to_a
    if alarms.length == 0
      alarms = self.where(:status => :active, :time.lt => (Time.now + 10.hours)).order_by([[:time, :asc],[:section_name, :asc]]).limit(1).to_a
      return [] unless alarms.first
      hh, mm, _ = Date.day_fraction_to_time(Sleep::Alarm.first.time-DateTime.now)
      return  [{
                :time => alarms.first.time.strftime("%A %H:%M"),
                :sections=>[
                    :name=>"Nästa väckning",
                    :items=>[{:name=>"om #{hh} timmar #{mm} minuter", :place=>"#{hh}:#{mm}", :pokes=>-1, :id=>0}]
                  ]
              }]
    end
    
    alarms.sort! do |a,b|
      arow, aplace = a.place_string.split("-").map(&:to_i)
      brow, bplace = b.place_string.split("-").map(&:to_i)
      
      #if its the same row, or rows that share a path
      #but not if they share 7 and 8 (dhw11 "snarken" layout)
      order = (arow <=> brow) 
      order = 0 if ((arow-brow).abs == 1 && [arow,brow].min%2 != 0) && !(arow+brow == 7+8) if order != 0
      order = (aplace <=> bplace) if order == 0
      order
    end
    
    times = {}
    
    #collect relevant data and group them by time and section
    alarms.each do |alarm|
      times[alarm.time] ||= {alarm.section_name => []}
      (times[alarm.time][alarm.section_name] ||= []) << {
        :name => alarm.person_name,
        :place => alarm.place_string,
        :pokes => alarm.poked,
        :id => alarm.id,
        :image_url => alarm.person_image_url
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
        :unixtime => time,
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
    #order by time
    times.sort do |a,b|
      a[:unixtime] <=> b[:unixtime]
    end
  end
end