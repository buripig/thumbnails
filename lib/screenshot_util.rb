class ScreenshotUtil
  
  FORMAT = "jpg"
  
  def self.capture(url)
    window_width  = Common.config[:window_width]  || 1024
    window_height = Common.config[:window_height] || 768
    stored_width  = Common.config[:stored_width]  || 512
    stored_height = Common.config[:stored_height] || 384
    
    file_name = save(url, window_width, window_height)
    blob = read(file_name)
    delete(file_name)
    Magick::ImageList.new.from_blob(blob).
        crop(0, 0, window_width, window_height).
        resize_to_fit(stored_width, stored_height).
        to_blob
  end
  
  def self.save(url, width, height)
    raise "URL is blank" if url.blank?
    browser = WebkitBrowser.new
    browser.visit(url)
    browser.resize_window(width + 15, height)
    file_name = SecureRandom.hex(16)
    browser.save_screenshot(path(file_name), width: width + 15, height: height)
    return file_name
  ensure
    browser.stop unless browser.nil?
  end
  
  def self.read(file_name)
    File.read(path(file_name))
  end
  
  def self.delete(file_name)
    File.delete(path(file_name))
  end
  
  def self.path(file_name)
    "#{Rails.root}/tmp/#{file_name}.#{FORMAT}"
  end
  
end