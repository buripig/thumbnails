class Screenshot < ActiveRecord::Base
  attr_accessible :url
  
  validates_presence_of :url
  validates_format_of :url, with: URI::regexp(%w(http https)), allow_blank: true
  
  enum :status, ScreenshotStatus
end
