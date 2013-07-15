module Five9
  class InboundCampaignStats < Statistics
    attr_accessor :stats
    def initialize(username,password,timeout=300)
      @stats = nil
      super(username,password,timeout)
    end

    def getStatistics(columns=[])
      @stats = super("InboundCampaignStatistics",columns)
    end

    def getStatisticsUpdate(long_polling_timeout=10000)
      super("InboundCampaignStatistics","Campaign Name",long_polling_timeout)
    end
  end
end
