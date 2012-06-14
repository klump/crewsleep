class Api::AlarmController < ApplicationController

  def create
    person = Crew::Person.find(params[:person])
    time = Time.parse(CGI::unescape(params[:time]))
    alarm = Sleep::Alarm.create({ :person => person, :time => time })

    render :nothing => true
  end

  def destroy
    alarm = Sleep::Alarm.find(params[:alarm])
    alarm.status = :deleted
    alarm.save

    render :nothing => true
  end

  def index_active
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

  def index_active_alternative
    alarms = Sleep::Alarm.where(:status => :active).order_by([:time, :asc])
    sections = Sleep::Section.all.to_a

    response = Sleep::Alarm.active_grouped_by_time_and_section
    render :json => response
  end

  def index_poked
    render :json=>Sleep::Alarm.active_poked
  end

  def poke
    alarm = Sleep::Alarm.find(params[:alarm])
    alarm.poked = alarm.poked.to_i+1
    alarm.save

    render :text => alarm.poked.to_i
  end

  def finish
    alarm = Sleep::Alarm.find(params[:alarm])
    alarm.status = :finished
    alarm.save

    render :nothing => true
  end

end