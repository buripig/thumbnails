class Screenshot < ActiveRecord::Base
  attr_accessible :url
  
  validates_presence_of :url
  validates_format_of :url, with: URI::regexp(%w(http https)), allow_blank: true
  
  enum :status, ScreenshotStatus
  
  after_create :delayed_capture
  
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
    self.captured_at = nil
    save!
  end
  
  private
  
  def delayed_capture
    self.delay.capture
  end
  
end
