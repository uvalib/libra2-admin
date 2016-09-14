class Work
   EDITABLE = [
         'abstract',
         'admin_notes',
         'advisers',
         'author_email',
         'author_first_name',
         'author_last_name',
         'embargo_end_date',
         'embargo_state',
         'degree',
         'notes',
         'rights',
         'title',
         'author_department',
         'author_institution',
         'depositor_email',
         'keywords',
         'language',
         'related_links',
         'sponsoring_agency',
   ]
   #    "advisers:["dpg3k\r\nDavid\r\nGoldstein\r\nUniversity of Virginia Library\r\nUniversity of Virginia"]
# advisers         - An array of advisers, each being a CRLF separated list of computingId, first name, last name, department, institution (optional)

   EDITABLE_TYPE = {
      'abstract' => 'textarea',
      'admin_notes' => 'textarea-append',
      'advisers' => 'advisers',
      'embargo_end_date' => 'date',
      'embargo_state' => 'combo',
      'keywords' => 'textarea-split',
      'notes' => 'textarea',
      'related_links' => 'textarea-split',
      'rights' => 'combo',
      'sponsoring_agency' => 'textarea-split',
   }

   HELP_BY_TYPE = {
      'default' => 'Enter the value of the field or clear it and hit "Apply"',
      'textarea-append' => 'Enter the value to be added to the field and hit "Apply"',
      'textarea-split' => 'Enter the value(s) of the field, separated by commas or clear it and hit "Apply"',
      'advisers' => 'Advisers help',
      'date' => 'Select the appropriate date and hit "Apply"',
      'combo' => 'Select the appropriate value and hit "Apply"'
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
      status, response = Libra2::api('GET', 'works')
      if Libra2::status_ok? status
         return response['works']
      else
         Rails.logger.error "==> Work.all: returns #{status} (#{response})"
         return []
      end
   end

   def self.find(id)
      status, response = Libra2::api('GET', "works/#{id}")
      if Libra2::status_ok? status
         if response['works'] && response['works'].length > 0
            work = response['works'][0]
            # The date is received as a full date and time, instead of just a day.
            work['embargo_end_date'] = work['embargo_end_date'].split("T")[0] if work['embargo_end_date'].present?

            return work
         else
            return {}
         end
      else
         Rails.logger.error "==> Work.find: returns #{status} (#{response})"
         return {}
      end
   end

  def self.latest
      return search( { status: 'pending', limit: 100 } )
   end

  def self.draft
      return search( { status: 'pending' } )
   end

   def self.submitted
      return search( { status: 'submitted' } )
   end

   def self.search(params)
      status, response = Libra2::api('GET', "works/search", params)
      if Libra2::status_ok? status
         return response['works']
      else
         Rails.logger.error "==> Work.search: returns #{status} (#{response})"
         return {}
      end
   end

   def self.update(user, id, params)
      # PUT: http://service.endpoint/api/v1/works/:id?auth=token&user=user
      p = { "work" => {} }
      Work::EDITABLE.each { |field|
         next if params[field].nil?
         case field
            when 'admin_notes'
               # these fields requires an array passed to it.
               p["work"][field] = [ params[field] ]

            when 'keywords', 'related_links', 'sponsoring_agency'
               # these fields are received as a comma separated string and split to an array
               p["work"][field] = params[field].split( ',' ).map { |s| s.strip }
            else
               # everything else...
               p["work"][field] = params[field]
         end
      }
      status, response = Libra2::api('PUT', "works/#{id}", { user: user }, p)

      if Libra2::status_ok? status
         Rails.logger.error "==> Work.update: returns #{status} (#{response})"
         return nil
      else
         return response
      end
   end

   def self.destroy(user, id)
      # DELETE: http://service.endpoint/api/v1/works/:id?auth=token&user=user
      status, response = Libra2::api('DELETE', "works/#{id}", { user: user })

      if Libra2::status_ok? status
         Rails.logger.error "==> Work.destroy: returns #{status} (#{response})"
         return nil
      else
         return response
      end
   end

end