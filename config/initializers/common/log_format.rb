# http://rubyist.g.hatena.ne.jp/rochefort/20100310
if Rails.env == "production"
  class Logger
    class SimpleFormatter < Logger::Formatter
      def call(severity, time, progname, msg)
        return nil if progname.blank? && msg.blank?
        msg = msg2str(msg)
        ts = "#{time.strftime('%y/%m/%d %H:%M:%S')}"
        if progname == msg
          "[%s #%d][%s] %s\n" % [ts, $$, severity, msg]
        else
          "[%s #%d][%s] %s : %s\n" % [ts, $$, severity, progname, msg]
        end
      end
    end
  end
else
  class Logger
    class SimpleFormatter < Logger::Formatter
      def call(severity, time, progname, msg)
        return nil if progname.blank? && msg.blank?
        msg = msg2str(msg)
        ts = "#{time.strftime('%H:%M:%S.%3N')}"
        if progname == msg
          "[%s %s] %s\n" % [ts, severity[0..1], msg]
        else
          "[%s %s] %s : %s\n" % [ts, severity[0..1], progname, msg]
        end
      end
    end
  end
end

# class Logger
#   class SimpleFormatter < Logger::Formatter
#     def call(severity, time, progname, msg)
#       format = "[%s #%d] %5s -- %s: %s\n"
#       format % ["#{time.strftime('%Y-%m-%d %H:%M:%S')}.#{'%06d' % time.usec.to_s}",
#                   $$, severity, progname, msg2str(msg)]
#     end
#   end
# end