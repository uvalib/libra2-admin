module ApplicationHelper

   def edit_button( key, work )
      data = { id: work['id'], label: key.humanize.titlecase, field: key }
      if can_edit_field?( key, work )

         # handle a special case...
         if key == 'filesets'
           data[:label] = Work.suggested_file_label_base( work )
           data[:help] = Work::HELP_BY_TYPE[ 'file-upload' ]
           return content_tag(:button, "Upload File", { class: "btn btn-primary file-upload", data: data })
         else
            data[:type] = Work::EDITABLE_TYPE[ key ] if Work::EDITABLE_TYPE[ key ].present?

            data[:help] = Work::HELP_BY_TYPE[ 'default' ]
            data[:help] = Work::HELP_BY_TYPE[ data[:type] ] if Work::HELP_BY_TYPE[ data[:type] ].present?
            return content_tag(:button, "Edit", { class: "edit btn btn-primary", data: data }) unless key == 'admin_notes'
            return content_tag(:button, "Add", { class: "add btn btn-primary", data: data })
         end
      else
        # cant edit field, no edit button
        return ''
      end
   end

   def format_value(key, value)

      case key
      when 'admin_notes'
         return raw(value.join( '<br>---<br>' ))
      when 'keywords', 'related_links', 'sponsoring_agency'
         return raw(value.join( ',' ))
      when 'filesets'
         html = ""
         value.each { |file|
            left = content_tag(:img, "", { src: file["thumb_url"]+"?auth=#{API_TOKEN}", class: "left"})

            name = content_tag(:div, "File: #{file["source_name"]}")
            label = content_tag(:div, "Display: #{file["file_name"]}")
            download = link_to("Download", file["file_url"]+"?auth=#{API_TOKEN}")
            delete = content_tag(:div, link_to('Delete', "/work_files/#{file["id"]}?work=#{@work['id']}", method: :delete, data: { confirm: 'Are you sure you really want to permanently remove this file?' }, class: "btn btn-primary file-delete"), {})
            right = content_tag(:div, download + name + label + delete, { class: "right" })

            html += content_tag(:div, raw(left+right), { class: "media-box"})
         }
         return content_tag(:div, raw(html), { class: "file-sets" })
      when 'advisors'
         advisers = []
         value.each { |adviser|
				fields = adviser.split("\n")
				if fields.length == 5
					advisers.push("<span class='adviser-label'>Computing ID:</span> #{fields[0]}<br><span class='adviser-label'>First Name:</span> #{fields[1]}<br><span class='adviser-label'>Last Name:</span> #{fields[2]}<br><span class='adviser-label'>Department:</span> #{fields[3]}<br><span class='adviser-label'>Institution:</span> #{fields[4]}")
				else
					# this should only happen if there were an error somewhere in saving an adviser.
            advisers.push(adviser.gsub("\n", "<br>"))
				end
         }
			   hidden = content_tag(:input, "", { value: value.join("\t"), type: "hidden", class: "inner-value"})
			   return hidden + raw(advisers.join( '<br>---<br>' ))
      when 'create_date', 'modified_date', 'embargo_end_date'
         return( formatted_date( value ) )
      else
         return value
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
       return false if [ 'embargo_end_date', 'embargo_state', 'published_date' ].include?( field )
    end

    return true
  end

end
