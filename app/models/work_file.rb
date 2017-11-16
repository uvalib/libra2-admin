class WorkFile

  def self.create( user, file_id, work_id, label )
    #POST: http://service.endpoint/api/v1/filesets?auth=token&user=user&file=file_id&work=work_id&label=label
    status, response = Libra2::api( 'POST', "filesets", { user: user, file: file_id, work: work_id, label: label })
    if Libra2::status_ok? status
      return nil
    else
      Rails.logger.error "==> WorkFile.create: returns #{status} (#{response})"
      return response
    end

  end

  def self.update( user, id, work_file)
    #PUT: http://service.endpoint/api/v1/filesets/:id?auth=token&user=user&file=file_id&work=work_id&label=label
    status, response = Libra2::api( 'PUT',
                                   "filesets/#{id}",
                                   { user: user,
                                     "fileset[file_name]": work_file[:label]
    })
    if Libra2::status_ok? status
      return nil
    else
      Rails.logger.error "==> WorkFile.update: returns #{status} (#{response})"
      return response
    end

  end

  def self.destroy( user, id )
    #DELETE: http://service.endpoint/api/v1/filesets/:id/?auth=token&user=user
    status, response = Libra2::api( 'DELETE', "filesets/#{id}", { user: user })
    if Libra2::status_ok? status
      return nil
    else
      Rails.logger.error "==> WorkFile.destroy: returns #{status} (#{response})"
      return response
    end
  end

end
