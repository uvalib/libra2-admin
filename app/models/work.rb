class Work
	def self.all
		status, response = Libra2::api("GET", 'works')
		if status
			return response['works']
		else
			puts "****"
			puts "**** Error in Work.all: #{response}"
			puts "****"
			return []
		end
	end

	def self.find(id)
		status, response = Libra2::api("GET", "works/#{id}")
		if status
			if response['works'] && response['works'].length > 0
				return response['works'][0]
			else
				return {}
			end
		else
			puts "****"
			puts "**** Error in Work.find: #{response}"
			puts "****"
			return {}
		end
	end

	def self.search(params)
		status, response = Libra2::api("GET", "works/search", params)
		if status
			return response['works']
		else
			puts "****"
			puts "**** Error in Work.search: #{response}"
			puts "****"
			return {}
		end
	end
end