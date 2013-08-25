class ScreenshotsController < ApplicationController
  
  def index
    @screenshot = Screenshot.new
    @screenshots = Screenshot.select("id, url, status, captured_at, accessed_at, created_at").order("id DESC")
  end
  
  def create
    @screenshot = Screenshot.new(params[:screenshot])
    @screenshot.status = ScreenshotStatus.waiing.value
    Screenshot.transaction do
      @screenshot.save!
    end
    redirect_to screenshots_url
  rescue ActiveRecord::RecordInvalid
    render action: :index
  end
  
  def destroy
    @screenshot = Screenshot.find(params[:id])
    Screenshot.transaction do
      @screenshot.destroy
    end
    redirect_to screenshots_url
  end
  
  def capture
    @screenshot = Screenshot.find(params[:id])
    Screenshot.transaction do
      @screenshot.capture
    end
    redirect_to screenshots_url
  end
  
  def image
    @screenshot = Screenshot.find(params[:id])
    send_data(@screenshot.image, type: "image/#{ScreenshotUtil::FORMAT}", disposition: "inline")
  end
  
  private
  
  def menu_token
    "manage"
  end
  
  def sub_menu_token
    "screenshot"
  end
  
end
