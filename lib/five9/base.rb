require 'savon'
module Five9
	class Base
		def initialize(username,password,given_wsdl,timeout=300)
      @client = Savon.client do
				wsdl "#{given_wsdl}#{username}"
        basic_auth [username, password]
			end
		end
	end
end