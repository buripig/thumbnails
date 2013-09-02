class ScreenshotsController < ApplicationController
  
  def index
    @screenshot = Screenshot.new
    @screenshots = Screenshot.for_list_page(params[:page])
  end
  
  def create
    @screenshot = Screenshot.new(params[:screenshot])
    @screenshot.status = ScreenshotStatus.waiting.value
    Screenshot.transaction do
      @screenshot.save!
    end
    redirect_to screenshots_url
  rescue ActiveRecord::RecordInvalid
    @screenshots = Screenshot.for_list_page
    render action: :index
  end
  
  def destroy
    @screenshot = Screenshot.find(params[:id])
    Screenshot.transaction do
      @screenshot.destroy
    end
    redirect_to screenshots_url
  end
  
  def image
    @screenshot = Screenshot.find(params[:id])
    if @screenshot.captured?
      data = @screenshot.image
    elsif @screenshot.waiting?
      dbg @screenshot
      data = File.read("#{Rails.root}/app/assets/images/now_printing.jpg")
      dbg data
    elsif @screenshot.error?
      data = File.read("#{Rails.root}/app/assets/images/capture_error.jpg")
    end
    send_data(data, type: "image/#{ScreenshotUtil::FORMAT}", disposition: "inline")
  end
  
  private
  
  def menu_token
    "manage"
  end
  
  def sub_menu_token
    "screenshot"
  end
  
end
