class Libra2

	def self.api(method, address, data = {}, payload = {})

		url = "#{LIBRA2_URL}/#{api_namespace}/#{address}?auth=#{API_TOKEN}"
		arr = data.to_a
		arr = arr.map { |pair| "#{pair[0]}=#{pair[1]}"}
		arr = arr.join("&")
		url = "#{url}&#{arr}" if arr.length > 0
    Rails.logger.info "==> #{method} #{url} #{payload.inspect}"
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
		return response.code, response if status_ok?( response.code )
		return response.code, response.message

	end

	def self.file_upload_url(user)
		return "#{LIBRA2_URL}/#{api_namespace}/files?user=#{user}"
	end

	def self.check_libra2_endpoint
		return healthcheck( LIBRA2_URL )
	end

	def self.check_userinfo_endpoint
		return healthcheck( USERINFO_URL )
	end

  def self.status_ok?( status )
    return status == 200
  end

  private

  def self.api_namespace
	   return 'api/v1'
	end

  def self.content_type_header
	   return { 'Content-Type' => 'application/json' }
	end

  def self.healthcheck( endpoint )

		begin
			response = HTTParty.get( "#{endpoint}/healthcheck" )
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