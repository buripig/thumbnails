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
  
end