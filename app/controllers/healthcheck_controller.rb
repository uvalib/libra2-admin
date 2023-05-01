class HealthcheckController < ApplicationController

  skip_before_action :require_auth

  # the basic health status object
  class Health
    attr_accessor :healthy
    attr_accessor :message

    def initialize( status, message )
      @healthy = status
      @message = message
    end

  end

  # the response
  class HealthCheckResponse

    attr_accessor :libraetd
    attr_accessor :userinfo

    def is_healthy?
      libraetd.healthy && userinfo.healthy
    end
  end

  # # GET /healthcheck
  # # GET /healthcheck.json
  def index
    status = get_health_status( )
    response = make_response( status )
    #render json: response, :status => response.is_healthy? ? 200 : 500
    render json: response, :status => 200   # dont want to continuously restart the container
  end

  private

  def get_health_status
    status = {}

    # check the deposit registration endpoint
    rc, message = RestEndpoint.check_libraetd_endpoint
    status[ :libraetd ] = Health.new( rc, message )

    # check the user information endpoint
    rc, message = RestEndpoint.check_userinfo_endpoint
    status[ :userinfo ] = Health.new( rc, message )

    return( status )
  end

  def make_response( health_status )
    r = HealthCheckResponse.new
    r.libraetd = health_status[ :libraetd ]
    r.userinfo = health_status[ :userinfo ]

    return( r )
  end

end
