module CommonHelper
  
  def dbg(*objs)
    Common.dbg(*objs)
  end
  
  def model_errors(obj, method)
    ret = []
    if errors = obj.errors[method]
      (errors.is_a?(Array) ? errors : [errors]).each do |error|
        ret << "<span class=\"field_error_message\">#{ERB::Util.h(error)}</span>"
      end
    end
    ret.join.html_safe
  end
  
  def model_name(model_class=nil)
    if model_class.nil?
      model_class = model_class_from_controller
    end
    model_class.nil? ? "" : model_class.model_name.human rescue ""
  end
  
  def attr_name(attr, model_class=nil)
    if model_class.nil?
      model_class = model_class_from_controller
    end
    model_class.nil? ? "" : model_class.human_attribute_name(attr) rescue ""
  end
  
  def model_class_from_controller
    controller.controller_name.classify.constantize rescue nil
  end
  
  def strftime(value, clazz, format)
    return "" if value.blank?
    unless value.respond_to?(:strftime)
      begin
        value = clazz.parse(value)
      rescue
        return ""
      end
    end
    value.strftime(format)
  end
  
  def date(value, format="%Y/%m/%d")
    strftime(value, Date, format)
  end
  
  def datetime(value, format="%Y/%m/%d %H:%M:%S")
    strftime(value, DateTime, format)
  end
  
  def time(value, format="%H:%M:%S")
    strftime(value, Time, format)
  end
  
end