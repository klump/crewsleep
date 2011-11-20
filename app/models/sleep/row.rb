class Sleep::Row
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :section, :class_name => "Sleep::Section"

  field :index, :type => Integer
  
  has_many :places, :class_name => "Sleep::Place"
end