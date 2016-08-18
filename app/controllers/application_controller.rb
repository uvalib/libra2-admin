class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

    def current_user
		#TODO-PER: Get this from shiboleth
		return "per4k"
    end
end
