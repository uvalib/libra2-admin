class HealthcheckController < ApplicationController

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

    attr_accessor :libra2
    attr_accessor :userinfo

    def is_healthy?
      libra2.healthy && userinfo.healthy
    end
  end

  # # GET /healthcheck
  # # GET /healthcheck.json
  def index
    status = get_health_status( )
    response = make_response( status )
    render json: response, :status => response.is_healthy? ? 200 : 500
  end

  private

  def get_health_status
    status = {}

    # check the deposit registration endpoint
    rc, message = Libra2.check_libra2_endpoint
    status[ :libra2 ] = Health.new( rc, message )

    # check the user information endpoint
    rc, message = Libra2.check_userinfo_endpoint
    status[ :userinfo ] = Health.new( rc, message )

    return( status )
  end

  def make_response( health_status )
    r = HealthCheckResponse.new
    r.libra2 = health_status[ :libra2 ]
    r.userinfo = health_status[ :userinfo ]

    return( r )
  end

end
