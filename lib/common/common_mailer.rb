class CommonMailer < ActionMailer::Base
  default from: Common.config[:email_from],
          to: Common.config[:stakeholder_emails],
          charset: "ISO-2022-JP"

  def exception(ex, req, params)
    subject = "#{Rails.application.class.to_s.gsub("::Application","")} Exception raised !"
    
    body = []
    body << "#{ex.class.to_s}: #{ex.message}"
    body << ""
    body << req.env["REQUEST_URI"]
    body << params.pretty_inspect
    body << ""
    body << ex.backtrace.join("\r\n")
    body << ""
    body << req.env.collect{|k,v|"#{k} = #{v}"}.join("\r\n")
    body = body.join("\r\n").force_encoding("utf-8")
    
    mail subject: subject do |format|
      format.text { render text: body }
    end
  end
  
end
