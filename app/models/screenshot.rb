class Screenshot < ActiveRecord::Base
  attr_accessible :url
  
  validates_presence_of :url
  validates_format_of :url, with: URI::regexp(%w(http https)), allow_blank: true
  
  enum :status, ScreenshotStatus
  
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
  
end
