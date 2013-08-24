class ApplicationController < ActionController::Base
  include CommonController
  
  protect_from_forgery
  
  rescue_from Exception, with: :common_rescue
  
  private
  
  def menu_token
    params[:controller]
  end
  helper_method :menu_token
  
  def sub_menu_token
    params[:action]
  end
  helper_method :sub_menu_token
end
