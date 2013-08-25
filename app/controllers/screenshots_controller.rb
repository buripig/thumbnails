class ScreenshotsController < ApplicationController
  
  def index
    @screenshot = Screenshot.new
    @screenshots = Screenshot.all
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
  
  private
  
  def menu_token
    "manage"
  end
  
  def sub_menu_token
    "screenshot"
  end
  
end
