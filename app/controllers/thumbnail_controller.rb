class ThumbnailController < ApplicationController
  before_filter :prepare
  
  PARSE_PATH_REGEX = /\/((.*)\/)?(http.+)/
  PARSE_OPTION_REGEX = /([0-9]+)x([0-9]+)/
  
  DEFAULT_WIDTH  = Common.config[:default_width]
  DEFAULT_HEIGHT = Common.config[:default_height]
  MICRO_WIDTH    = Common.config[:micro_width]
  MICRO_HEIGHT   = Common.config[:micro_height]
  SMALL_WIDTH    = Common.config[:small_width]
  SMALL_HEIGHT   = Common.config[:small_height]
  LARGE_WIDTH    = Common.config[:large_width]
  LARGE_HEIGHT   = Common.config[:large_height]
  
  def image
    screenshot = Screenshot.where("url = ?", @url).first
    if screenshot
      if screenshot.captured?
        send_image(screenshot, @width, @height)
      elsif screenshot.waiting?
        send_system_image("now_printing", @width, @height)
      elsif screenshot.error?
        send_system_image("capture_error", @width, @height)
      end
    else
      send_system_image("error", @width, @height)
    end
  end
  
  def system_image
    send_system_image(params[:image_name], @width, @height)
  end
  
  private
  
  def prepare
    @url = get_url
    @width, @height = get_width_and_height(params[:option])
  end
  
  def get_url
    PARSE_PATH_REGEX.match(request.original_fullpath)
    return $3
  end
  
  def get_width_and_height(option)
    return DEFAULT_WIDTH, DEFAULT_HEIGHT if option.blank?
    if option == "micro"
      return MICRO_WIDTH, MICRO_HEIGHT
    elsif option == "small"
      return SMALL_WIDTH, SMALL_HEIGHT
    elsif option == "default"
      return DEFAULT_WIDTH, DEFAULT_HEIGHT
    elsif option == "large"
      return LARGE_WIDTH, LARGE_HEIGHT
    else
      PARSE_OPTION_REGEX.match(option)
      return $1.present? ? $1.to_i : DEFAULT_WIDTH, $2.present? ? $2.to_i : DEFAULT_HEIGHT
    end
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
