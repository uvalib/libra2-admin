class Libra2
	def self.api(method, address, data = {}, payload = {})
		url = "#{LIBRA2_URL}/api/v1/#{address}?auth=#{API_TOKEN}"
		arr = data.to_a
		arr = arr.map { |pair| "#{pair[0]}=#{pair[1]}"}
		arr = arr.join("&")
		url = "#{url}&#{arr}" if arr.length > 0
		puts "API: #{method} #{url} #{payload.inspect}"
		if method == "GET"
			response = HTTParty.get(url, headers: { 'Content-Type' => 'application/json' })
		elsif method == "POST"
			response = HTTParty.post(url, body: JSON.dump(payload), headers: { 'Content-Type' => 'application/json' })
		elsif method == "PUT"
			response = HTTParty.put(url, body: JSON.dump(payload), headers: { 'Content-Type' => 'application/json' })
		elsif method == "DELETE"
			response = HTTParty.delete(url, headers: { 'Content-Type' => 'application/json' })
		else
			return false, "Unrecognized method"
		end
		return true, response if response.code == 200
		return false, response.message

	end

	def self.file_upload_url(user)
		return "#{LIBRA2_URL}/api/v1/filesets?user=#{user}"
	end

	def self.options()

		begin
			response = HTTParty.get("#{LIBRA2_URL}/options")
			if response.code == 200
				return response['options']
			else
				# If the server is available, but there is an error in getting the options.
				return {'department' => [ 'Libra2 Server Error' ], 'degree' => []}
			end
		rescue => e
			puts e
			# If the server isn't available at all, it throws an exception.
			return {'department' => [ 'Libra2 Server Not Available' ], 'degree' => []}
		end
	end

	def self.register(requester, department, degree, computing_id_list)

		begin
			url = "#{LIBRA2_URL}/?auth=#{API_TOKEN}"
			ids = Libra2.parse_user_ids(computing_id_list)
			ids = ids.join(",")
			data = { requester: requester, for: ids, department: department, degree: degree }
			response = HTTParty.post(url, body: JSON.dump(data), headers: { 'Content-Type' => 'application/json' })
			return true, nil if response.code == 200
			return false, response.message
		rescue => e
			puts e
			return false, e.message
		end

	end

	def self.parse_user_ids( user_id_list )
		# Takes a string and turns it into an array of computing ids.
		return user_id_list.split(/\W+/) if user_id_list.present?
		return []
	end

	def self.check_libra2_endpoint
		begin
			response = HTTParty.get("#{LIBRA2_URL}/healthcheck")
			if response.code == 200
				return true, ''
			else
				return false, "Endpoint returns #{response.code}"
			end
		rescue => ex
			return false, "Endpoint returns #{ex}"
		end
	end

	def self.check_userinfo_endpoint
		begin
			response = HTTParty.get("#{USERINFO_URL}/healthcheck")
			if response.code == 200
				return true, ''
			else
				return false, "Endpoint returns #{response.code}"
			end
		rescue => ex
			return false, "Endpoint returns #{ex}"
		end
	end

end