module ScreenshotsHelper
  
  def screenshot_status(status)
    enum = ScreenshotStatus.value_of(status)
    return "" if enum.nil?
    content_tag :span, enum.name, style: "color: #{enum.color}"
  end
  
end
