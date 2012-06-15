class Api::AlarmController < ApplicationController

  def create
    person = Crew::Person.find(params[:person])
    time = Time.parse(CGI::unescape(params[:time]))
    alarm = Sleep::Alarm.create({ :person => person, :time => time })

    render :nothing => true
  end

  def destroy
    alarm = Sleep::Alarm.find(params[:id])
    alarm.status = :deleted
    alarm.save

    render :nothing => true
  end

  def index_active
    render :json => Sleep::Alarm.active_grouped_by_time_and_place
  end

  def index_poked
    render :json=>Sleep::Alarm.active_poked
  end

  def poke
    alarm = Sleep::Alarm.find(params[:id])
    alarm.poked = alarm.poked.to_i+1
    alarm.save

    render :text => alarm.poked.to_i
  end

  def finish
    alarm = Sleep::Alarm.find(params[:id])
    alarm.status = :finished
    alarm.save

    render :nothing => true
  end

end