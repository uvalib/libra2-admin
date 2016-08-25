module ApplicationHelper
	def edit_button(key, work_id)
		if Work::EDITABLE.include?(key)
			data = { id: work_id, label: key.humanize.titlecase, field: key }
			data[:type] = Work::EDITABLE_TYPE[key] if Work::EDITABLE_TYPE[key].present?
			return content_tag(:button, "Edit", { class: "edit btn btn-primary", data: data })
		else
			return ""
		end
	end

	def format_value(key, value)
		if key == "admin_notes"
			return raw(value.join("<br>---<br>"))
		elsif key == "filesets"
			html = ""
			value.each { |file|
				left = content_tag(:img, "", { src: file["thumb_url"]+"?auth=#{API_TOKEN}", class: "left"})

				right = content_tag(:div, content_tag(:div, "File: #{file["source_name"]}") +
					content_tag(:div, "Display: #{file["file_name"]}") +
					link_to("Download", file["file_url"]+"?auth=#{API_TOKEN}"), { class: "right" })

				html += content_tag(:div, raw(left+right), { class: "media-box"})
			}
			return raw(html)
		elsif key == "advisers"
			advisers = []
			value.each { |adviser|
				advisers.push(adviser.gsub("\n", "<br>"))
			}
			return raw(advisers.join("<br>---<br>"))
		else
			return value
		end
	end
end
