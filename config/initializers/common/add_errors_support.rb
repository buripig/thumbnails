ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag.sub!(/class="/, 'class="field_with_errors ').nil?
    html_tag.sub! /(\/?>)/, ' class="field_with_errors"\1'
  end
  html_tag.html_safe
end

ActionView::Helpers::FormBuilder.class_eval do
  def errors(method)
    @template.model_errors(object, method)
  end
end