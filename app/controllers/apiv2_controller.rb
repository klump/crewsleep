class Apiv2Controller < ApiController
  def fetch_active_alarms
    alarms = Sleep::Alarm.where(:status => :active).order_by([:time, :asc])
    sections = Sleep::Section.all.to_a
    
    response = Sleep::Alarm.active_grouped_by_time_and_section
    render :json => response
  end
  
  def info
    if params[:text]
      i = Info.last || Info.new
      i.text = params[:text]
      i.save!
    end
    
    render :text=>Info.last.text
  end
  
  def fetch_alarms_poked
    render :json=>Sleep::Alarm.active_poked
  end
end