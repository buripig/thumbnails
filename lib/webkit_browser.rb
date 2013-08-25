class WebkitBrowser
  
  if Rails.env == "production"
    @@headless = Headless.new
    @@headless.start
  end
  
  def initialize
    @session = create_capybara_session
  end
  
  def visit(url)
    @session.visit(url)
    self
  end
  
  def save_screenshot(path, opts={})
    @session.save_screenshot(path, opts)
    self
  end
  
  def resize_window(width, height)
    @session.driver.resize_window(width, height)
  end
  
  private
  
  def create_capybara_session
    Capybara.run_server = false
    Capybara.register_driver :webkit do |app|
      Capybara::Webkit::Driver.new(app)
    end
    Capybara::Session.new(:webkit)
  end
  
end