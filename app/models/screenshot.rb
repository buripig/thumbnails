class Screenshot < ActiveRecord::Base
  attr_accessible :url
  
  validates_presence_of :url
  validates_format_of :url, with: URI::regexp(%w(http https)), allow_blank: true
  validates_uniqueness_of :url
  
  enum :status, ScreenshotStatus
  
  after_create :delayed_capture
  
  scope :for_list_page, -> {
    select("id, url, status, captured_at, accessed_at, created_at").order("id DESC")
  }
  
  def waiting?
    self.status == ScreenshotStatus.waiting.value
  end
  
  def captured?
    self.status == ScreenshotStatus.captured.value
  end
  
  def error?
    self.status == ScreenshotStatus.error.value
  end
  
  def capture
    self.image = ScreenshotUtil.capture(self.url)
    self.status = ScreenshotStatus.captured.value
    self.captured_at = DateTime.now
    save!
  rescue => ex
    self.image = nil
    self.status = ScreenshotStatus.error.value
    self.error_info = cretae_error_info(ex)
    self.captured_at = nil
    save!
  end
  
  def self.update_at_accessed(url)
    self.update_all("accessed_at = current_timestamp, updated_at = current_timestamp", ["url = ?", url])
  end
  
  private
  
  def delayed_capture
    self.delay.capture
  end
  
  def cretae_error_info(ex)
    ret = []
    ret << "#{ex.class.to_s}: #{ex.message}"
    ret << ""
    ret << ex.backtrace.join("\r\n")
    ret.join("\r\n")
  end
  
end
