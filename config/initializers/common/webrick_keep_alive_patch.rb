# https://bugs.ruby-lang.org/attachments/2300/204_304_keep_alive.patch

if Rails.env == "development"
  module WEBrick
    class HTTPResponse
      def setup_header()
        @reason_phrase    ||= HTTPStatus::reason_phrase(@status)
        @header['server'] ||= @config[:ServerSoftware]
        @header['date']   ||= Time.now.httpdate

        # HTTP/0.9 features
        if @request_http_version < "1.0"
          @http_version = HTTPVersion.new("0.9")
          @keep_alive = false
        end

        # HTTP/1.0 features
        if @request_http_version < "1.1"
          if chunked?
            @chunked = false
            ver = @request_http_version.to_s
            msg = "chunked is set for an HTTP/#{ver} request. (ignored)"
            @logger.warn(msg)
          end
        end

        # Determine the message length (RFC2616 -- 4.4 Message Length)
        if @status == 304 || @status == 204 || HTTPStatus::info?(@status)
          @header.delete('content-length')
          @body = ""
        elsif chunked?
          @header["transfer-encoding"] = "chunked"
          @header.delete('content-length')
        elsif %r{^multipart/byteranges} =~ @header['content-type']
          @header.delete('content-length')
        elsif @header['content-length'].nil?
          unless @body.is_a?(IO)
            @header['content-length'] = @body ? @body.bytesize : 0
          end
        end

        # Keep-Alive connection.
        if @header['connection'] == "close"
           @keep_alive = false
        elsif keep_alive?
          # -- FIX START --
          #if chunked? || @header['content-length']
          if chunked? || @header['content-length'] || @status == 304 || @status == 204
          # -- FIX END --
            @header['connection'] = "Keep-Alive"
          else
            msg = "Could not determine content-length of response body. Set content-length of the response or set Response#chunked = true"
            @logger.warn(msg)
            @header['connection'] = "close"
            @keep_alive = false
          end
        else
          @header['connection'] = "close"
        end

        # Location is a single absoluteURI.
        if location = @header['location']
          if @request_uri
            @header['location'] = @request_uri.merge(location)
          end
        end
      end
    end
  end
end