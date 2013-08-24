module CommonController
  
  def noroute
    render nothing: true, status: 404
  end
  
  def exception_test
    raise "Test Exception"
  end
  
  private
  
  def common_rescue(ex)
    send_exception_mail(ex)
  ensure
    raise ex
  end
  
  def send_exception_mail(ex)
    CommonMailer.exception(ex, request, params).deliver if Common.config[:exception_mail_enable] == true
  end
  
end