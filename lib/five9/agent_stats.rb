module Five9
	class AgentStats < Statistics
		def initialize(username,password,given_wsdl)
			super(username,password,given_wsdl)
		end

		def getStatistics(columns=[])
			super("AgentStatistics",columns)
		end

		def getStatisticsUpdate(long_polling_timeout=10000)
			super("AgentStatistics",long_polling_timeout)
		end
	end
end