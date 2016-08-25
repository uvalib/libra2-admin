class ApplicationController < ActionController::Base
	#protect_from_forgery with: :exception
	protect_from_forgery unless: -> { request.format.json? }

    def current_user
		#TODO-PER: Get this from shiboleth
		return "per4k"
    end
end
