class Sleep::Section
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :valid_minutes, :type => Array

  embeds_many :rows, :class_name => "Sleep::Row"
  
  #add a row with index and range places
  # ex gen_row(1..40)
  def gen_row(idx, range)
    row = rows.create(:index=>idx)
    range.each do |i|
      row.places.create(:index=>i)
    end
  end
end