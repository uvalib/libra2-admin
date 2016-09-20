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

      # can be edited by depositor
      'title',
      'author_email',
      'author_first_name',
      'author_last_name',
      'author_department',
      'author_institution',
      'advisers',
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
      'admin_notes',
      'filesets'
   ]

   #
   # specify which fields are editable
   #
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
         'published_date',
   ]

   EDITABLE_TYPE = {
      'abstract' => 'textarea',
      'admin_notes' => 'textarea-append',
      'advisers' => 'advisers',
      'author_department' => 'combo',
      'degree' => 'combo',
      'embargo_end_date' => 'date',
      'embargo_state' => 'combo',
      'keywords' => 'textarea-split',
      'notes' => 'textarea',
      'language' => 'combo',
      'related_links' => 'textarea-split',
      'rights' => 'combo',
      'sponsoring_agency' => 'textarea-split',
   }

   HELP_BY_TYPE = {
      'default' => 'Enter the value of the field or clear it and hit "Apply"',
      'textarea-append' => 'Enter the value to be added to the field and hit "Apply"',
      'textarea-split' => 'Enter the value(s) of the field, separated by commas or clear it and hit "Apply"',
      'advisers' => 'Enter a UVA Computing ID to automatically fill the remaining fields for this person.',
      'date' => 'Select the appropriate date and hit "Apply"',
      'combo' => 'Select the appropriate value and hit "Apply"',
      'file-upload' => 'Select a file, update the file label as necessary and hit "Apply"'
   }

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
         #puts "==> #{field} == '#{params[field]}'"
         case field
            when 'advisers'
               p["work"][field] = params[field].split("\t")
            when 'admin_notes'
               # these fields requires an array passed to it.
               p["work"][field] = [ params[field] ]

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

   def self.degree_options
      return( get_options( 'degrees' ) )
   end

   def self.department_options
      return( get_options( 'departments' ) )
   end

   def self.language_options
      return( get_options( 'languages' ) )
   end

   def self.rights_options
      return( get_options( 'rights' ) )
   end

   def self.suggested_file_label_base( work )

     # set the defaults
     next_ix = work['filesets'].length + 1
     last_name = 'last'
     first_name = 'first'
     year = Time.now.year
     degree = 'degree'

     # update if we can
     last_name = work['author_last_name'].split( ' ' )[ 0 ] unless work['author_last_name'].blank?
     first_name = work['author_first_name'].split( ' ' )[ 0 ] unless work['author_first_name'].blank?
     degree = work['degree'].split( ' ' )[ 0 ] unless work['degree'].blank?

     # construct the template
     return "#{next_ix}_#{last_name}_#{first_name}_#{year}_#{degree}"
   end

  private

  def self.get_options( which )
     status, response = Libra2::api( 'GET', "options/#{which}" )
     if Libra2::status_ok? status
        return response['options']
     else
        Rails.logger.error "==> Work.#{which}_options: returns #{status} (#{response})"
        return []
     end
  end

end