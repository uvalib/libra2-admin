class WorkFile
	def self.destroy(user, id)
		#DELETE: http://service.endpoint/api/v1/fileset/:id/?auth=token&user=user
		status, response = Libra2::api("DELETE", "fileset/#{id}", { user: user })

		if status
			return nil
		else
			return response
		end
	end
end
