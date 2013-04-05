require 'savon'
module Five9
	class Base
		def initialize(username,password,given_wsdl)
			@client = Savon::Client.new do
				wsdl.document = given_wsdl
				http.auth.basic(username,password)
			end
		end
	end
end