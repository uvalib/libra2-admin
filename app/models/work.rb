class Work

   #
   # specify which fields are displayable
   #
   DISPLAYABLE = [
      'id',
      'status',
      'identifier',
      'create_date',
      'modified_date',
      'published_date',
      'source',

      # can be edited by depositor
      'title',
      'author_email',
      'author_first_name',
      'author_last_name',
      'author_department',
      'author_institution',
      'advisors',
      'abstract',
      'rights',
      'keywords',
      'language',
      'related_links',
      'sponsoring_agency',
      'notes',
      'degree',

      # can only be edited by admin
      'depositor_email',
      'embargo_state',
      'embargo_end_date',
      'embargo_period',
      'admin_notes',
      'filesets'
   ]

   #
   # specify which fields are editable
   #
   EDITABLE = [
       'abstract',
       'admin_notes',
       'advisors',
       'author_department',
       'author_email',
       'author_first_name',
       'author_institution',
       'author_last_name',
       'degree',
       'depositor_email',
       'embargo_end_date',
       'embargo_state',
       'embargo_period',
       'filesets',
       'keywords',
       'language',
       'notes',
       'published_date',
       'related_links',
       'rights',
       'sponsoring_agency',
       'title',
       'file_label'
   ]

   EDITABLE_TYPE = {
      'abstract' => 'textarea',
      'admin_notes' => 'textarea-append',
      'advisors' => 'advisors',
      'author_department' => 'combo',
      'degree' => 'combo',
      'embargo_end_date' => 'date',
      'embargo_state' => 'dropdown',
      'embargo_period' => 'dropdown',
      'keywords' => 'textarea-split',
      'notes' => 'textarea',
      'language' => 'dropdown',
      'published_date' => 'date',
      'related_links' => 'textarea-split',
      'rights' => 'dropdown',
      'sponsoring_agency' => 'textarea-split',
      'file_label' => 'text',
   }

   HELP_BY_TYPE = {
      'default' => 'Enter the value of the field or clear it and hit "Apply"',
      'textarea-append' => 'Enter the value to be added to the field and hit "Apply"',
      'textarea-split' => 'Enter the value(s) of the field, separated by commas or clear it and hit "Apply"',
      'advisors' => 'Enter a UVA Computing ID to automatically fill the remaining fields for this person.',
      'date' => 'Select the appropriate date and hit "Apply"',
      'dropdown' => 'Select the appropriate value and hit "Apply"',
      'combo' => 'Select the appropriate value or enter a new one and hit "Apply"',
      'file-upload' => 'Select a file, update the file label as necessary and hit "Apply"',
      'file-edit' => 'Update the file label and hit "Apply"'
   }

   # taken from generic work definitions
   SOURCE_SIS = 'sis'.freeze
   SOURCE_OPTIONAL = 'optional'.freeze
   SOURCE_LEGACY = 'libra'.freeze
   SOURCE_INGEST = 'ingest'.freeze

   def self.all
      status, response = RestEndpoint::api('GET', 'works')
      if RestEndpoint::status_ok? status
         return response['works'] if response['works']
         Rails.logger.error "==> Work.all: returns empty response (#{response})"
         return []
      else
         Rails.logger.error "==> Work.all: returns #{status} (#{response})"
         return []
      end
   end

   def self.find(id)
      status, response = RestEndpoint::api('GET', "works/#{id}")
      if RestEndpoint::status_ok? status
         if response['works'] && response['works'].length > 0
            return response['works'][0]
         else
            return {}
         end
      else
         Rails.logger.error "==> Work.find: returns #{status} (#{response})"
         return {}
      end
   end

  def self.latest
      return search( { create_date: "#{Date.today - 7}:#{Date.today}" } )
   end

  def self.draft
      return search( { status: 'pending' } )
   end

   def self.submitted
      return search( { status: 'submitted' } )
   end

   def self.sis_only
     return search( { work_source: SOURCE_SIS } )
   end

   def self.optional_only
     return search( { work_source: SOURCE_OPTIONAL } )
   end

   def self.ingest_only
     return search( { work_source: SOURCE_INGEST } )
   end

   def self.libra_only
     return search( { work_source: SOURCE_LEGACY } )
   end

   def self.search(params)
      status, response = RestEndpoint::api('GET', "works/search", params)
      if RestEndpoint::status_ok? status
         return response['works'] if response['works']
         Rails.logger.error "==> Work.search: returns empty response (#{response})"
         return []
      else
         Rails.logger.error "==> Work.search: returns #{status} (#{response})"
         return []
      end
   end

   def self.update(user, id, params)
      # PUT: http://service.endpoint/api/v1/works/:id?auth=token&user=user
      p = { "work" => {} }
      Work::EDITABLE.each { |field|
         next if params[field].nil?
         #puts "==> #{field} == '#{params[field]}'"
         case field
            when 'advisors'
               # special case where we are clearing the field
               if params[field] == "\n\n\n\n\n" || params[field].blank?
                 p["work"][field] = ['']
               else
                 p["work"][field] = params[field].split("\t")
               end
            when 'admin_notes'
               # these fields requires an array passed to it; add a timestamp too
               p["work"][field] = [ "#{DateTime.now} | #{params[field]}" ]

            when 'keywords', 'related_links', 'sponsoring_agency'
               # special case where we are clearing the field
               if params[field] == ''
                  p["work"][field] = ['']
               else
                  # these fields are received as a comma separated string and split to an array
                  p["work"][field] = params[field].split( ',' ).map { |s| s.strip }
               end

            else
               # everything else...
               p["work"][field] = params[field]
         end
      }
      status, response = RestEndpoint::api('PUT', "works/#{id}", {user: user }, p)

      if RestEndpoint::status_ok? status
         return nil
      else
         Rails.logger.error "==> Work.update: returns #{status} (#{response})"
         return response
      end
   end

   def self.publish( user, id )
     p = { "work" => { "status" => "submitted" } }
     status, response = RestEndpoint::api('PUT', "works/#{id}", {user: user }, p)

     if RestEndpoint::status_ok? status
       return nil
     else
       Rails.logger.error "==> Work.publish: returns #{status} (#{response})"
       return response
     end
   end

   def self.unpublish( user, id )
     p = { "work" => { "status" => "pending" } }
     status, response = RestEndpoint::api('PUT', "works/#{id}", {user: user }, p)

     if RestEndpoint::status_ok? status
       return nil
     else
       Rails.logger.error "==> Work.unpublish: returns #{status} (#{response})"
       return response
     end
   end

   def self.destroy(user, id)
      # DELETE: http://service.endpoint/api/v1/works/:id?auth=token&user=user
      status, response = RestEndpoint::api('DELETE', "works/#{id}", {user: user })

      if RestEndpoint::status_ok? status
         return nil
      else
         Rails.logger.error "==> Work.destroy: returns #{status} (#{response})"
         return response
      end
   end

   def self.degree_options
     Rails.cache.fetch( "options/degree_options", expires_in: 30.minutes ) do
       get_options( 'degrees' )
     end
   end

   def self.department_options
     Rails.cache.fetch( "options/department_options", expires_in: 30.minutes ) do
       get_options( 'departments' )
     end
   end

   def self.language_options
     Rails.cache.fetch( "options/language_options", expires_in: 30.minutes ) do
       get_options( 'languages' )
     end
   end

   def self.rights_options
     Rails.cache.fetch( "options/rights_options", expires_in: 30.minutes ) do
       get_options( 'rights' )
     end
   end

   def self.embargo_options
     Rails.cache.fetch( "options/embargo_options", expires_in: 30.minutes ) do
       get_options( 'embargos' )['state_options']
     end
   end

   def self.embargo_period_options
     Rails.cache.fetch( "options/embargo_period_options", expires_in: 30.minutes ) do
       get_options( 'embargos' )['period_options']
     end
   end

   def self.suggested_file_label_base( work )

     # set the defaults
     next_ix = work['filesets'].length + 1
     last_name = 'last'
     first_name = 'first'

     date_string =
       if work['published_date'].blank?
         work['create_date']
       else
         four_digit_year = work['published_date'].match(/\d{4}/).to_s
         if four_digit_year
           Date.strptime(four_digit_year, '%Y').to_s
         else
          work['published_date']
         end
       end

     year = Date.parse(date_string).year rescue Time.now.year

     degree = 'degree'

     # update if we can
     last_name = work['author_last_name'].split( ' ' )[ 0 ] unless work['author_last_name'].blank?
     first_name = work['author_first_name'].split( ' ' )[ 0 ] unless work['author_first_name'].blank?
     degree = work['degree'].split( ' ' )[ 0 ] unless work['degree'].blank?

     # construct the template filtering out any suspect characters
     return self.label_filter( "#{next_ix}_#{last_name}_#{first_name}_#{year}_#{degree}" )
   end

  private

  def self.label_filter( label )
     return '' if label.blank?
     return label.gsub( /[^0-9a-zA-Z\-_]/, '' )
  end

  def self.get_options( which )
     status, response = RestEndpoint::api('GET', "options/#{which}" )
     if RestEndpoint::status_ok? status
        return response['options']
     else
        Rails.logger.error "==> Work.#{which}_options: returns #{status} (#{response})"
        return []
     end
  end

end
