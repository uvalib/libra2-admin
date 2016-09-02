class WorkFile
	def self.destroy(user, id)
		#DELETE: http://service.endpoint/api/v1/filesets/:id/?auth=token&user=user
		status, response = Libra2::api("DELETE", "filesets/#{id}", { user: user })

		if status
			return nil
		else
			return response
		end
	end
end
