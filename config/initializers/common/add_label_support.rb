ActionView::Helpers::InstanceTag.class_eval do
  
  alias :old_to_radio_button_tag :to_radio_button_tag
  def to_radio_button_tag(tag_value, options = {})
    label = options.delete(:label)
    ret = old_to_radio_button_tag(tag_value, options)
    if label
      ret += " ".html_safe
      ret += to_label_tag(label, {value: tag_value})
    end
    ret
  end
  
  alias :old_to_check_box_tag :to_check_box_tag
  def to_check_box_tag(options = {}, checked_value = "1", unchecked_value = "0")
    label = options.delete(:label)
    ret = old_to_check_box_tag(options, checked_value, unchecked_value)
    if label
      ret += " ".html_safe
      ret += to_label_tag(label)
    end
    return ret
  end
  
end

ActionView::Helpers::FormTagHelper.class_eval do
  
  alias :old_radio_button_tag :radio_button_tag
  def radio_button_tag(name, value, checked = false, options = {})
    label = options.delete(:label)
    id = "#{sanitize_to_id(name)}_#{sanitize_to_id(value)}"
    ret = old_radio_button_tag(name, value, checked, options)
    if label
      ret += " ".html_safe
      ret += label_tag(id, label)
    end
    return ret
  end
  
  alias :old_check_box_tag :check_box_tag
  def check_box_tag(name, value = "1", checked = false, options = {})
    label = options.delete(:label)
    id = "#{sanitize_to_id(name)}_#{sanitize_to_id(value)}"
    ret = old_check_box_tag(name, value, checked, options.merge({id: id}))
    if label
      ret += " ".html_safe
      ret += label_tag(id, label)
    end
    return ret
  end
end
