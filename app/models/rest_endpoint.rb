class RestEndpoint

  # http request timeouts in seconds
  HTTP_DEFAULT_TIMEOUT ||= 30
  HTTP_GET_TIMEOUT ||= 300

  include HTTParty

  #debug_output $stdout
  default_timeout HTTP_DEFAULT_TIMEOUT
  headers 'Content-Type' => 'application/json'

  def self.api(method, address, data = {}, payload = {})

    url = "#{LIBRA_ETD_API_URL}/#{api_namespace}/#{address}?auth=#{API_TOKEN}"
    arr = data.to_a
    arr = arr.map { |pair| "#{pair[0]}=#{pair[1]}"}
    arr = arr.join("&")
    url = "#{url}&#{arr}" if arr.length > 0
    Rails.logger.info "==> #{method} #{url} #{payload.inspect}"
    timer = TimingBehavior.new( url ).start
    timeout = HTTP_DEFAULT_TIMEOUT

    begin
      case method
      when 'GET'
        timeout = HTTP_GET_TIMEOUT
        response = self.get( url, { timeout: timeout } )
      when 'POST'
        response = self.post( url, body: JSON.dump(payload) )
      when 'PUT'
        response = self.put( url, body: JSON.dump(payload) )
      when 'DELETE'
        response = self.delete( url )
      else
        return :internal_error, 'Unrecognized method'
      end

      timer.log_completed( "(status #{response.code})")
      return response.code, response if status_ok?( response.code )
      return response.code, response.message
    rescue Net::ReadTimeout
      return :internal_error, "Timeout after #{timeout} seconds"
    rescue => ex
      return :internal_error, "Endpoint returns #{ex}"
    end

  end

  def self.file_upload_url(user)
    return "#{LIBRA_ETD_URL}/#{api_namespace}/files?user=#{user}"
  end

  def self.hosted_public_url( id )
    return "#{LIBRA_ETD_URL}/#{public_view}/#{id}"
  end

  def self.check_libraetd_endpoint
    return healthcheck(LIBRA_ETD_API_URL )
  end

  def self.check_userinfo_endpoint
    return healthcheck( USERINFO_URL )
  end

  def self.status_ok?( status )
    return status == 200
  end

  private

  def self.public_view
    return 'public_view'
  end

  def self.api_namespace
    return 'api/v1'
  end

  def self.healthcheck( endpoint )

    begin
      url = "#{endpoint}/healthcheck"
      timer = TimingBehavior.new( url ).start
      response = self.get( url )
      timer.log_completed( "(status #{response.code})")

      if status_ok?( response.code )
        return true, ''
      else
        return false, "Endpoint returns #{response.code}"
      end
    rescue Net::ReadTimeout
      return false, "Timeout after #{HTTP_DEFAULT_TIMEOUT} seconds"
    rescue => ex
      return false, "Endpoint returns #{ex}"
    end
  end

end
