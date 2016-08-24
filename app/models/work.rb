class Work
	EDITABLE = [
		'title',
		"author_email",
		"author_first_name",
		"author_last_name",
		"abstract",
		"embargo_state",
		"embargo_end_date",
		"admin_notes"
	]
	EDITABLE_TYPE = {
		"abstract" => "textarea",
		"embargo_state" => "state"
	}
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

	def self.update(user, id, params)
		# PUT: http://service.endpoint/api/v1/works/:id?auth=token&user=user
		p = { "work" => {} }
		Work::EDITABLE.each { |field|
			if params[field]
				p["work"][field] = params[field]
			end
		}
		status, response = Libra2::api("PUT", "works/#{id}", { user: user }, p)

		if status
			return nil
		else
			return response
		end
	end

	def self.destroy(user, id)
		# DELETE: http://service.endpoint/api/v1/works/:id?auth=token&user=user
		status, response = Libra2::api("DELETE", "works/#{id}", { user: user })

		if status
			return nil
		else
			return response
		end
	end
end