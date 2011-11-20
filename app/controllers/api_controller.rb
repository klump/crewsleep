require 'time'

class ApiController < ApplicationController

  def fetch_person
    render :json => Crew::Person.by_nick_or_ccoid(params[:q]).to_json(
    	:except => [ :created_at, :updated_at ],
    	:include => [ :place, :alarms ]
    )
  end

  def add_alarm
  end

  def book_place
  	person = Crew::Person.find(params[:person])
  	place = Sleep::Section.find(params[:section]).rows.find(params[:row]).places.find(params[:place])
	person.place = place
	person.save
  	
  	render :nothing => true
  end

  def set_alarm
    person = Crew::Person.find(params[:person])
    time = Time.parse(params[:time])
  	alarm = Sleep::Alarm.create({ :person => person, :time => time })
  	
  	render :nothing => true
  end

  def delete_alarm
  
  end
  
  def finish_alarm
  
  end
  
  def fetch_alarms
  
  end
  
  def fetch_place_info
  	place = Sleep::Place.find(params[:place])
  	section = Sleep::Section.first(:conditions => { "rows._id" => place.row_id })
  	row = section.rows.find(place.row_id)
  	
  	render :json => {
  	  :name => section.name+" "+row.index.to_s+"-"+place.index.to_s,
  	  :valid_minutes => section.valid_minutes
  	}.to_json
  end

  def fetch_places
    render :json => Sleep::Section.all.order_by([:name, :asc]).to_json(
    	:include => {
    		:rows => {
    			:include => {
    				:places => {
	    				:exclude => [ :created_at, :update_at ]
	    			}
	    		},
	    		:exclude => [ :created_at, :updated_at ]
    		}
    	},
    	:exclude => [ :created_at, :updated_at ]
    )
  end

  def save_places
    Sleep::Section.delete_all

    params[:places].each_value do |section_data|
      valid_minutes = Array.new
      puts section_data
      section_data["valid_minutes"].split(",").each do |part|
      	valid_minutes.push(part.to_i)
      end
      section = Sleep::Section.create({ :name => section_data["name"], :valid_minutes => valid_minutes })

      row_index = 1
      section_data["rows"].each_value do |row_data|
        row = section.rows.create({ :index => row_index })
        row_index += 1

        place_count = 1
        row_data.to_i.times do
          row.places.create({ :index => place_count })
          place_count += 1
        end
      end
    end

    render :nothing => true
  end

end
