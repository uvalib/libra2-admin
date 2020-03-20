#require_dependency 'app/helpers/token_helper'
include TokenHelper

module ApplicationHelper

   def edit_button( key, work )
      data = { id: work['id'], label: key.humanize.titlecase, field: key }
      if can_edit_field?( key, work )

         case key
           when 'filesets'
              data[:label] = Work.suggested_file_label_base( work )
              data[:help] = Work::HELP_BY_TYPE[ 'file-upload' ]
              return content_tag(:button, "Upload File", { class: "btn btn-primary file-upload", data: data })

           when 'admin_notes'
             data[:type] = Work::EDITABLE_TYPE[ key ]
             data[:help] = Work::HELP_BY_TYPE[ data[:type] ]
             return content_tag(:button, "Add", { class: "add btn btn-primary", data: data })

           when 'notes', 'title', 'abstract'

              data[:type] = Work::EDITABLE_TYPE[ key ] if Work::EDITABLE_TYPE[ key ].present?
              data[:help] = Work::HELP_BY_TYPE[ 'default' ]
              data[:help] = Work::HELP_BY_TYPE[ data[:type] ] if Work::HELP_BY_TYPE[ data[:type] ].present?
              # keep an unformatted version for text fields
              hidden = hidden_field_tag("#{key}_value", unescape_field(work[key]))
              return hidden + content_tag(:button, "Edit", { class: "edit btn btn-primary", data: data })

           else
              data[:type] = Work::EDITABLE_TYPE[ key ] if Work::EDITABLE_TYPE[ key ].present?
              data[:help] = Work::HELP_BY_TYPE[ 'default' ]
              data[:help] = Work::HELP_BY_TYPE[ data[:type] ] if Work::HELP_BY_TYPE[ data[:type] ].present?
              return content_tag(:button, "Edit", { class: "edit btn btn-primary", data: data })
         end
      else
        # cant edit field, no edit button
        return ''
      end
   end

   def edit_file(file)
     data = { file_id: file['id'],
              id: @work['id'],
              field: 'file_label',
              type:  Work::EDITABLE_TYPE[ 'file_label' ],
              label:  "File Label",
              help: Work::HELP_BY_TYPE[ 'file-edit' ]
     }
     value = hidden_field_tag(:value, file['file_name'], class: 'file_label')
     return value + content_tag(:button, "Edit", { class: "edit btn btn-primary text-edit file_label", data: data })

   end

   def format_value(key, value)

      case key
      when 'id'
        return raw( format_id( @work ) )
      when 'notes'
        return raw( simple_format(unescape_field( value ) ) )
      when 'abstract'
        return raw( simple_format( unescape_field( value ) ) )
      when 'title'
        return raw( simple_format( unescape_field( value ) ) )
      when 'admin_notes'
         # sort and split the leading timestamp
         formatted = value.sort.map { |v| v.include?( "|") ? v.split( "|", 2 )[ 1 ].strip : v }
         # format for display
         return raw(formatted.join( '<br>---<br>' ))
      when 'keywords', 'related_links', 'sponsoring_agency'
         return raw(value.join( ',' ))
      when 'filesets'
         html = ""
         value.each { |file|
            left = content_tag(:img, "", { src: file["thumb_url"]+"?auth=#{TokenHelper.page_auth_token}", class: "left"})

            name = content_tag(:div, "File: #{file["source_name"]}")
            label = content_tag(:div, "Display: #{file["file_name"]}", class: 'file_label')
            uploaded = content_tag(:div, "Uploaded: #{file["date_uploaded"]}")
            download = link_to("Download", file["file_url"]+"?auth=#{TokenHelper.page_auth_token}")
            edit = edit_file(file)
            delete = content_tag(:div, link_to('Delete', "/work_files/#{file["id"]}?work=#{@work['id']}", method: :delete, data: { confirm: 'Are you sure you really want to permanently remove this file?' }, class: "btn btn-primary file-delete"), {})
            right = content_tag(:div, download + name + label + uploaded + edit + delete, { class: "right" })

            html += content_tag(:div, raw(left+right), { class: "media-box"})
         }
         return content_tag(:div, raw(html), { class: "file-sets" })
      when 'advisors'
         advisors = []
         # advisors are tagged with a numeric index so sorting them ensures they are presented in the correct order
         value.sort!

         value.each do |advisor|
           fields = advisor.split("\n")
           fields.push('') if fields.length == 4 # if the last item is empty, the split command will miss it.
           fields.push('') if fields.length == 5 # if the last item is empty, the split command will miss it.

           if fields.length == 6
              advisors.push("<div><span class='advisor-label'>Computing ID:</span>#{fields[1]}<br><span class='advisor-label'>First Name:</span>#{fields[2]}<br><span class='advisor-label'>Last Name:</span>#{fields[3]}<br><span class='advisor-label'>Department:</span>#{fields[4]}<br><span class='advisor-label'>Institution:</span>#{fields[5]}</div>")
           else
              # this should only happen if there were an error somewhere in saving an advisor.
              advisors.push(advisor.gsub("\n", "<br>"))
           end
         end
         hidden = content_tag(:input, "", { value: value.join("\t").html_safe, type: "hidden", class: "inner-value"})
         return hidden + raw("<br>" + advisors.join( '<br>---<br>' ))

      when 'modified_date', 'embargo_end_date'
         return( value )
        when 'source'
          toks = value.split( ':' )
          return value if toks.length < 2
          return "#{Work::SOURCE_SIS.upcase.strip} (ID: #{toks[ 1 ]})" if value.start_with?( Work::SOURCE_SIS )
          return "#{Work::SOURCE_OPTIONAL.titleize.strip} (ID: #{toks[ 1 ]})" if value.start_with?( Work::SOURCE_OPTIONAL )
          return "#{Work::SOURCE_LEGACY.titleize.strip} (ID: #{toks[ 1 ]})" if value.start_with?( Work::SOURCE_LEGACY )
          return "#{Work::SOURCE_INGEST.titleize.strip} (File: #{toks[ 1 ]})" if value.start_with?( Work::SOURCE_INGEST )
          return value
      else
         return value
      end
   end

   def format_audit( audit )
     return( "#{audit['created_at']}|#{audit['user_id']}|#{truncate(audit['what'].gsub( '\\r\\n', ', ').gsub( '\\n', ', '), length: 80 )}" )
   end

   def format_id( work )
     if is_published( work )
       if work['url'].present?
        link_to( work['id'], work['url'], target: '_blank'  )
       else
         # DOI submission failed
         "#{work['id']} (Submitted with no DOI)"
       end
     else
        return work['id']
     end
   end

   def format_local_link(work )
     if is_published( work )
       link_to('direct link', RestEndpoint.hosted_public_url(work['id'] ), target: '_blank'  )
     else
       return ''
     end
   end

  private

  #
  # determine conditions for being able to edit specific fields
  #
  def can_edit_field?( field, work )

    # not if they are not defined as editable
    return false if Work::EDITABLE.include?( field ) == false

    # if we are not published them some fields cannot be edited
    if is_published( work ) == false
       return false if [ 'published_date' ].include?( field )
    end

    return true
  end

  def unescape_field( field )
    return '' if field.blank?
    return CGI.unescapeHTML( String.new field.to_s )
  end

end
