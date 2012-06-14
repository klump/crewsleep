class Api::InfoController < ApplicationController

  def show
    info = Info.last
    text = info.text unless info.nil?
    render :text => text
  end

  def update
    i = Info.last || Info.new
    i.text = params[:text]
    i.save!

    render :text => Info.last.text
  end

end