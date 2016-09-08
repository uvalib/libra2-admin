class ApplicationController < ActionController::Base
	#protect_from_forgery with: :exception
	protect_from_forgery unless: -> { request.format.json? }

	# Adds Libra2 authentication behavior
	include AuthenticationBehavior

	rescue_from ActionController::RoutingError, :with => :render401
	rescue_from ActionView::MissingTemplate, :with => :render404

	def render401
	   render :file => "#{Rails.root}/public/401.html", :status => :unauthorized, :layout => false
	end

	def render404
		render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false
	end

end
