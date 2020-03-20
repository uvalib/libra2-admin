#
# helpers for creating outbound authorization tokens
#
module TokenHelper

  #
  # our shared secret for JWT validation
  #
  @@secret = nil

  #
  # create a short lived token
  #
  def service_auth_token

    if @@secret.nil?
      @@secret = get_secret
    end

    return jwt_auth_token( @@secret, 5 )
  end

  #
  # create a longer lived token
  #
  def page_auth_token

    if @@secret.nil?
      @@secret = get_secret
    end

    return jwt_auth_token( @@secret, 60 )
  end

  private

  # create a time limited JWT for service authentication
  def self.jwt_auth_token( secret, expire_minutes )

    # expire in 5 minutes
    exp = Time.now.to_i + expire_minutes * 60

    # just a standard claim
    exp_payload = { exp: exp }

    return JWT.encode exp_payload, secret, 'HS256'

  end

  #
  # load the secret from the configuration file
  #
  def self.get_secret
    cfg = load_config( "token.yml" )
    cfg[:secret]
  end

  #
  # load the supplied configuration file
  #
  def self.load_config( filename )

    fullname = "#{Rails.application.root}/config/#{filename}"
    begin
      config_erb = ERB.new( IO.read( fullname ) ).result( binding )
    rescue StandardError => ex
      raise( "#{filename} could not be parsed with ERB. \n#{ex.inspect}" )
    end

    begin
      yml = YAML.load( config_erb )
    rescue Psych::SyntaxError => ex
      raise "#{filename} could not be parsed as YAML. \nError #{ex.message}"
    end

    config = yml.symbolize_keys
    return config[ Rails.env.to_sym ].symbolize_keys || {}
  end

end

#
# end of file
#
