class Libra2

	def self.api(method, address, data = {}, payload = {})

		url = "#{LIBRA2API_URL}/#{api_namespace}/#{address}?auth=#{API_TOKEN}"
		arr = data.to_a
		arr = arr.map { |pair| "#{pair[0]}=#{pair[1]}"}
		arr = arr.join("&")
		url = "#{url}&#{arr}" if arr.length > 0
    Rails.logger.info "==> #{method} #{url} #{payload.inspect}"
    timer = TimingBehavior.new( url ).start
		begin
			case method
			when 'GET'
				response = HTTParty.get(url, headers: content_type_header )
			when 'POST'
				response = HTTParty.post(url, body: JSON.dump(payload), headers: content_type_header )
			when 'PUT'
				response = HTTParty.put(url, body: JSON.dump(payload), headers: content_type_header )
			when 'DELETE'
				response = HTTParty.delete(url, headers: content_type_header )
			else
				return :internal_error, 'Unrecognized method'
			end

      timer.log_completed( "(status #{response.code})")
		  return response.code, response if status_ok?( response.code )
		  return response.code, response.message
		rescue => ex
			return :internal_error, "Endpoint returns #{ex}"
		end

	end

	def self.file_upload_url(user)
		return "#{LIBRA2UPLOAD_URL}/#{api_namespace}/files?user=#{user}"
	end

	def self.hosted_public_url( id )
		return "#{LIBRA2API_URL}/#{public_view}/#{id}"
	end

	def self.check_libra2_endpoint
		return healthcheck( LIBRA2API_URL )
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

  def self.content_type_header
	   return { 'Content-Type' => 'application/json' }
	end

  def self.healthcheck( endpoint )

		begin
      url = "#{endpoint}/healthcheck"
      timer = TimingBehavior.new( url ).start
			response = HTTParty.get( url )
      timer.log_completed( "(status #{response.code})")

			if status_ok?( response.code )
				return true, ''
			else
				return false, "Endpoint returns #{response.code}"
			end
		rescue => ex
			return false, "Endpoint returns #{ex}"
		end
	end

end