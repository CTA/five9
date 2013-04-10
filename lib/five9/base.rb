require 'savon'
module Five9
	class Base
		def initialize(username,password,given_wsdl,timeout=300)
			@client = Savon::Client.new do
				wsdl.document = given_wsdl + username
				http.auth.basic(username,password)
				http.read_timeout = timeout	
			end
		end
	end
end