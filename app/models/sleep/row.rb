class Sleep::Row
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :section, :class_name => "Sleep::Section"

  field :index, :type => Integer
  
  has_many :places, :class_name => "Sleep::Place"

  after_update do |row|
    row.places.each do |place|
      place.people.each do |person|
        person.alarms.each do |alarm|
          alarm.update_person_and_place
          alarm.save
        end
      end
    end
  end
end