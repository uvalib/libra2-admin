class Libra2

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