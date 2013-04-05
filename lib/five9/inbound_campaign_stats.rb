module Five9
	class InboundCampaignStats < Statistics
		def initialize(username,password,given_wsdl)
			super(username,password,given_wsdl)
		end

		def getStatistics(columns=[])
			super("InboundCampaignStatistics",columns=[])
		end

		def getStatisticsUpdate(long_polling_timeout=10000)
			super("InboundCampaignStatistics",long_polling_timeout)
		end
	end
end