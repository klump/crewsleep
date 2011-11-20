class Sleep::Section
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :valid_minutes, :type => Array

  embeds_many :rows, :class_name => "Sleep::Row"
end