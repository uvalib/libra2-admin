module AuthenticationBehavior
	extend ActiveSupport::Concern

	included do
		before_action :require_auth
	end

	private

	def current_user
		return ENV['HTTP_REMOTE_USER'] if Rails.env == 'development'
		return request.env['HTTP_REMOTE_USER']
	end

	def require_auth

    #
    # if we cannot get the user, then raise an exception...
    #
		if current_user.blank?
			raise ActionController::RoutingError.new( 'Forbidden' )
		end

	end

end
