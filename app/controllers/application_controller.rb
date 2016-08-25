class ApplicationController < ActionController::Base
	#protect_from_forgery with: :exception
	protect_from_forgery unless: -> { request.format.json? }

    def current_user
		return ENV['HTTP_REMOTE_USER'] if Rails.env == 'development'
		return request.env['HTTP_REMOTE_USER']
    end
end
