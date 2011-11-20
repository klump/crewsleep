class Sleep::Place
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :row, :class_name => "Sleep::Row"

  field :index, :type => Integer
  
  has_many :people, :class_name => "Crew::Person"
  
  def name
  	"test"
  end
end