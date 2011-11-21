class Apiv2Controller < ApiController
  def fetch_active_alarms
    alarms = Sleep::Alarm.where(:status => :active).order_by([:time, :asc])
    sections = Sleep::Section.all.to_a
    
    response = Sleep::Alarm.active_grouped_by_time_and_section
    render :json => response
  end
end