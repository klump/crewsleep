class Sleep::Place
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :row, :class_name => "Sleep::Row"

  field :index, :type => Integer
  
  has_many :people, :class_name => "Crew::Person"
  
  def name
  	"test"
  end
  
  def to_s
    "#{row.index}-#{index}"
  end
  
  def row
    section.rows.where("_id" => row_id).first
  end
  
  def section
    Sleep::Section.where("rows._id" => row_id).first
  end
end