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
end
