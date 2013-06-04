require 'savon'
module Five9
	class Base
		def initialize(username,password,given_wsdl,timeout=300)
      #For some reason httpclient is not compatible with api.five9.com so we have to manually set this option
      HTTPI.adapter = :net_http
      @client = Savon.client do
				wsdl "#{given_wsdl}#{username}"
        basic_auth [username, password]
			end
		end
	end
end