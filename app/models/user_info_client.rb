require_dependency 'base_client'

module ServiceClient

   class UserInfoClient < BaseClient

     #
     # configure with the appropriate configuration file
     #
     def initialize
       load_config( "userinfo.yml" )
     end

     #
     # singleton stuff
     #

     @@instance = new

     def self.instance
       return @@instance
     end

     private_class_method :new

     #
     # get specified user information
     #
     def get_by_id( id )
       url = "#{self.url}/user/#{id}?auth=#{self.authtoken}"
       status, response = rest_get( url )
       return status, response['user'] if ok?( status ) && response['user']
       return status, ''
     end

     #
     # helpers
     #

     def authtoken
       configuration[ :authtoken ]
     end

     def url
       configuration[ :url ]
     end

   end
end
