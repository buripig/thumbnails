ActionController::Base.class_eval do
  def dbg(*objs)
    Common.dbg(*objs)
  end
end

ActiveRecord::Base.class_eval do
  def dbg(*objs)
    Common.dbg(*objs)
  end
end
