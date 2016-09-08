class Work
	EDITABLE = [
		'author_email',
		'author_first_name',
		'author_last_name',
		'title',
		'abstract',
		'embargo_state',
		'embargo_end_date',
		'notes',
		'admin_notes',
		'rights',
    'language',
    'keywords',
    'related_links',
    'sponsoring_agency',
#		'advisers',
	]
	# 	"advisers:["dpg3k\r\nDavid\r\nGoldstein\r\nUniversity of Virginia Library\r\nUniversity of Virginia"]
# advisers         - An array of advisers, each being a CRLF separated list of computingId, first name, last name, department, institution (optional)

	EDITABLE_TYPE = {
		'abstract' => 'textarea',
		'notes' => 'textarea',
		'admin_notes' => 'textarea-append',
		'embargo_state' => 'combo',
		'rights' => 'combo',
		'embargo_end_date' => 'date',
  	'keywords' => 'textarea-split',
		'related_links' => 'textarea-split',
		'sponsoring_agency' => 'textarea-split',
#		'advisers' => 'textarea-split',
	}
	RIGHTS = [
		'CC-BY (permitting free use with proper attribution)',
		'CC0 (permitting unconditional free use, with or without attribution)',
		'None (users must comply with ordinary copyright law)'
	]
	EMBARGO_STATE = [
		{ text: 'No Embargo', value: 'open' },
		{ text: 'UVA Only Embargo', value: 'authenticated' },
		{ text: 'Metadata Only Embargo', value: 'restricted' }
	]

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
				work = response['works'][0]
				# The date is received as a full date and time, instead of just a day.
				work['embargo_end_date'] = work['embargo_end_date'].split("T")[0] if work['embargo_end_date'].present?

				return work
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
				p["work"][field] = [ p["work"][field] ] if field == "admin_notes" # this item requires an array passed to it.
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