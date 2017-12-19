class Audit

   def self.all
      status, response = RestEndpoint::api('GET', 'audit')
      if RestEndpoint::status_ok? status
         return response['audits'] if response['audits']
         Rails.logger.error "==> Audit.all: returns empty response (#{response})"
         return []
      else
         Rails.logger.error "==> Audit.all: returns #{status} (#{response})"
         return []
      end
   end

  def self.user( user )
    status, response = RestEndpoint::api('GET', "audit/user/#{user}" )
    if RestEndpoint::status_ok? status
      return response['audits'] if response['audits']
      Rails.logger.error "==> Audit.user: returns empty response (#{response})"
      return []
    else
      Rails.logger.error "==> Audit.user: returns #{status} (#{response})"
      return []
    end
   end

  def self.work( work_id )
    status, response = RestEndpoint::api('GET', "audit/work/#{work_id}" )
    if RestEndpoint::status_ok? status
      return response['audits'] if response['audits']
      Rails.logger.error "==> Audit.work: returns empty response (#{response})"
      return []
    else
      Rails.logger.error "==> Audit.work: returns #{status} (#{response})"
      return []
    end
  end

  private

end