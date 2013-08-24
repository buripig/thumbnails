class Common
  
  def self.dbg(*objs)
    objs.each do |obj|
      Rails.logger.debug "DEBUG:\n================================================================\n#{obj.pretty_inspect}\n================================================================"
    end
  end
  
  def self.config
    Rails.application.config.common
  end
  
end