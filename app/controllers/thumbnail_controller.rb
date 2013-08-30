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
  
  @@memcached = Memcached.new("localhost:11211", 
                              binary_protocol: true,
                              prefix_key: "thumbnails_")
  MEMCACHED_TTL = 60 * 60 * 24
  
  def image
    if cache = find_cache(@url, @width, @height)
      send_cache(cache)
      return
    end
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
      @screenshot        = Screenshot.new
      @screenshot.url    = @url
      @screenshot.status = ScreenshotStatus.waiting.value
      Screenshot.transaction do
        @screenshot.save!
      end
      send_system_image("now_printing", @width, @height)
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
  
  def get_memcached
    @@memcached.clone
  end
  
  def cache_key(url, width, height)
    "/#{width}x#{height}/#{url}"
  end
  
  def store_cache(data, screenshot, width, height)
    get_memcached.set(cache_key(screenshot.url, width, height), data, MEMCACHED_TTL)
  end
  
  def find_cache(url, width, height)
    get_memcached.get(cache_key(url, width, height))  rescue nil
  end
  
  def send_cache(cache)
    send_data(cache, type: "image/#{ScreenshotUtil::FORMAT}", disposition: "inline")
    Screenshot.update_at_accessed(@url)
  end
  
  def send_image(screenshot, width, height)
    data = Magick::ImageList.new.from_blob(screenshot.image).resize(width, height).to_blob
    send_data(data, type: "image/#{ScreenshotUtil::FORMAT}", disposition: "inline")
    Screenshot.update_at_accessed(@url)
    store_cache(data, screenshot, width, height)
  end
  
  def send_system_image(image_name, width, height)
    path = "#{Rails.root}/app/assets/images/#{image_name}.jpg"
    data = Magick::ImageList.new.from_blob(File.read(path)).resize(width, height).to_blob
    send_data(data, type: "image/jpg", disposition: "inline")
  end
  
end
