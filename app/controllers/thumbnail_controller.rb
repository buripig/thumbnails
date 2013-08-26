class ThumbnailController < ApplicationController
  before_filter :prepare
  
  PARSE_PATH_REGEX = /\/((.*)\/)?(http.+)/
  PARSE_OPTION_REGEX = /([0-9]+)x([0-9]+)/
  DEFAULT_WIDTH = Common.config[:default_width]
  DEFAULT_HEIGHT = Common.config[:default_height]
  
  def image
    screenshot = Screenshot.where("url = ?", @url).first
    if screenshot
      if screenshot.captured?
        send_image(screenshot, @width, @height)
      else
        render nothing: true
      end
    else
      render nothing: true
    end
  end
  
  def system_image
    send_system_image(params[:image_name], @width, @height)
  end
  
  private
  
  def prepare
    @option, @url = get_option_and_url
    @width, @height = get_width_and_height(@option)
  end
  
  def get_option_and_url
    PARSE_PATH_REGEX.match(request.original_fullpath)
    return $2, $3
  end
  
  def get_width_and_height(option)
    return DEFAULT_WIDTH, DEFAULT_HEIGHT if option.blank?
    PARSE_OPTION_REGEX.match(option)
    return $1.present? ? $1.to_i : DEFAULT_WIDTH, $2.present? ? $2.to_i : DEFAULT_HEIGHT
  end
  
  def send_image(screenshot, width, height)
    data = Magick::ImageList.new.from_blob(screenshot.image).resize(width, height).to_blob
    send_data(data, type: "image/#{ScreenshotUtil::FORMAT}", disposition: "inline")
    screenshot.accessed_at = DateTime.now
    screenshot.save!
  end
  
  def send_system_image(image_name, width, height)
    path = "#{Rails.root}/app/assets/images/#{image_name}.jpg"
    data = Magick::ImageList.new.from_blob(File.read(path)).resize(width, height).to_blob
    send_data(data, type: "image/jpg", disposition: "inline")
  end
  
end
