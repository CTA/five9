module Five9
	class AcdStatus < Statistics
		def initialize(username,password,given_wsdl)
			super(username,password)
		end

		def getStatistics(columns=[])
			super("ACDStatus",columns)
		end

		def getStatisticsUpdate(long_polling_timeout=10000)
			super("ACDStatus",long_polling_timeout)
		end
	end
end