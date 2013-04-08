module Five9
	class AcdStatus < Statistics
		attr_accessor :stats
		def initialize(username,password)
			@stats = nil
			super(username,password)
		end

		def getStatistics(columns=[])
			@stats = super("ACDStatus",columns)
		end

		def getStatisticsUpdate(long_polling_timeout=10000)
			super("ACDStatus","Skill Name",long_polling_timeout)
		end
	end
end