class ThumbnailController < ApplicationController
  
  PARSE_PATH_REGEX = /\/((.*)\/)?(http.+)/
  PARSE_OPTION_REGEX = /([0-9]+)x([0-9]+)/
  DEFAULT_WIDTH = Common.config[:default_width]
  DEFAULT_HEIGHT = Common.config[:default_height]
  
  def image
    option, url = get_option_and_url
    width, height = get_width_and_height(option)
    screenshot = Screenshot.where("url = ?", url).first
    
    if screenshot
      if screenshot.captured?
        send_capture(screenshot, width, height)
      else
        render nothing: true
      end
    else
      render nothing: true
    end
  end
  
  private
  
  def get_option_and_url
    PARSE_PATH_REGEX.match(request.original_fullpath)
    return $2, $3
  end
  
  def get_width_and_height(option)
    return DEFAULT_WIDTH, DEFAULT_HEIGHT if option.blank?
    PARSE_OPTION_REGEX.match(option)
    return $1.present? ? $1.to_i : DEFAULT_WIDTH, $2.present? ? $2.to_i : DEFAULT_HEIGHT
  end
  
  def send_capture(screenshot, width, height)
    data = Magick::ImageList.new.from_blob(screenshot.image).resize(width, height).to_blob
    send_data(data, type: "image/#{ScreenshotUtil::FORMAT}", disposition: "inline")
    screenshot.accessed_at = DateTime.now
    screenshot.save!
  end
  
end
