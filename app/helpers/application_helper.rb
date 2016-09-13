module ApplicationHelper
	def edit_button(key, work_id)
		if Work::EDITABLE.include?(key)
			data = { id: work_id, label: key.humanize.titlecase, field: key }
			data[:type] = Work::EDITABLE_TYPE[key] if Work::EDITABLE_TYPE[key].present?
			return content_tag(:button, "Edit", { class: "edit btn btn-primary", data: data }) unless key == 'admin_notes'
			return content_tag(:button, "Add", { class: "add btn btn-primary", data: data })
		elsif key == "filesets"
			return content_tag(:button, "Upload File", class: "btn btn-primary file-upload")
		else
			return ""
		end
	end

	def format_value(key, value)

		case key
		when 'admin_notes', 'keywords', 'related_links', 'sponsoring_agency'
			return raw(value.join( '<br>---<br>' ))
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
			return raw(html)
		when 'advisers'
			advisers = []
			value.each { |adviser|
				advisers.push(adviser.gsub("\n", "<br>"))
			}
			return raw(advisers.join( '<br>---<br>' ))
		else
			return value
		end
	end
end
