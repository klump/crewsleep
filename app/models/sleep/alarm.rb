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
end