require 'time'
require 'uri'

class ApiController < ApplicationController

  def fetch_person
	if (params[:q].length == 12 && params[:q] =~ /^\d+$/) then
		code = UpcCode.new(params[:q])
		person = Crew::PersonHelper.fetch_person_by_cco_id(code.to_i)
	else
		person = Crew::PersonHelper.fetch_person_by_username(params[:q])
	end
    render :json => person.to_json(
    	:except => [ :created_at, :updated_at ],
    	:include => [ :place, :alarms ]
    )
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
    time = Time.parse(CGI::unescape(params[:time]))
  	alarm = Sleep::Alarm.create({ :person => person, :time => time })
  	
  	render :nothing => true
  end

  def poke
	alarm = Sleep::Alarm.find(params[:alarm])
	alarm.poked = alarm.poked.to_i+1
	alarm.save

  render :text => alarm.poked.to_i
  end

  def delete_alarm
    alarm = Sleep::Alarm.find(params[:alarm])
	alarm.status = :deleted
	alarm.save

	render :nothing => true
  end
  
  def finish_alarm
    alarm = Sleep::Alarm.find(params[:alarm])
	alarm.status = :finished
	alarm.save

	render :nothing => true
  end
  
  def fetch_active_alarms
    alarms = Sleep::Alarm.where(:status => :active).order_by([:time, :asc])
    sections = Sleep::Section.all.to_a
    
	response = Array.new

	alarms.each do |alarm|
	  time = nil
	  response.each do |_time|
		if (_time[:time] == alarm.time) then
			time = _time
			break
		end
	  end
	  if (time == nil) then
		  time = Hash.new
		  time[:time] = alarm.time
		  time[:sections] = Hash.new
		  response.push(time)
	  end

	  section = nil
	  row = nil
	  sections.each do |_section|
		section = _section
	    row = _section.rows.where("_id" => alarm.person.place.row_id).first
		break if !row.nil?
	  end

	  if (!time[:sections].has_key?(section.name)) then
		  time[:sections][section.name] = Array.new
	  end

	  result = time[:sections][section.name].push({
		:_id => alarm._id,
		:poked => alarm.poked,
		:status => alarm.status,
	    :place_name => row.index.to_s+"-"+alarm.person.place.index.to_s,
		:person => alarm.person
	  })
	  
	  result.sort! do |a,b|
      a = a[:place_name].split("-").map{|i|i.to_i}
      b = b[:place_name].split("-").map{|i|i.to_i}
      if a.first == b.first
        a.last <=> b.last
      else
        a.first <=> b.first
      end
    end
    result
	end

	render :json => response
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
