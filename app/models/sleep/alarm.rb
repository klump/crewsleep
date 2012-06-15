# encoding: UTF-8

class Sleep::Alarm
  include Mongoid::Document
  include Mongoid::Timestamps

  field :time, :type => DateTime
  field :poked, :type => Integer, :default => 0
  field :status, :type => Symbol, :default => :active

  belongs_to :person, :class_name => "Crew::Person"

  field :person_username, :type => String
  field :person_image_url, :type => String
  field :section_name, :type => String
  field :row_index, :type => Integer
  field :place_index, :type => Integer
  field :place_sorting_index, :type => Integer

  before_save do |alarm|
    alarm.update_person_and_place
  end

  def update_person_and_place
    self.person_username = person.username
    self.person_image_url = person.avatar_url
    self.section_name = person.place.section.name
    self.row_index = person.place.row.index
    self.place_index = person.place.index
    self.place_sorting_index = person.place.sorting_index
  end
  
  scope :active, where(status: :active)
  
  def self.active_poked
    self.active.where(:poked.gt => 0)
  end

  def self.active_grouped_by_time_and_place
    alarms = self.active.order_by([[:time, :asc], [:section_name, :asc], [:place_sorting_index, :asc]])
    alarms.each do |alarm|
      puts "#{alarm.time} - #{alarm.section_name}:#{alarm.place_sorting_index} - #{alarm.row_index}-#{alarm.place_index}"
    end

    times = []
    current_time = nil
    current_section = nil
    alarms.each do |alarm|
      if (current_time.nil? || alarm.time != current_time[:time])
        current_time = {
          time: alarm.time,
          sections: []
        }
        times.append(current_time)
        current_section = nil
      end

      if (current_section.nil? || alarm.section_name != current_section[:name])
        current_section = {
            name: alarm.section_name,
            alarms: []
        }
        current_time[:sections].append(current_section)
      end

      current_section[:alarms].append(alarm)
    end
    times
  end
  
  def self.active_grouped_by_time_and_section
    alarms = self.where(:status => :active, :time.lt => (Time.now + 2.hours)).order_by([[:time, :asc],[:section_name, :asc]]).to_a

    if (alarms.length == 0)
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
      #if its the same row, or rows that share a path
      #but not if they share 7 and 8 (dhw11 "snarken" layout)
      order = (a.row_index <=> b.row_index)
      order = 0 if ((a.row_index-b.row_index).abs == 1 && [a.row_index,b.row_index].min%2 != 0) && !(a.row_index+b.row_index == 7+8) if order != 0
      order = (a.place_index <=> b.place_index) if order == 0
      order
    end
    
    times = {}
    
    #collect relevant data and group them by time and section
    alarms.each do |alarm|
      times[alarm.time] ||= {alarm.section_name => []}
      (times[alarm.time][alarm.section_name] ||= []) << {
        :name => alarm.person_username,
        :place => "#{alarm.row_index}-#{alarm.place_index}",
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