module Five9
	class Statistics < Base
		def initialize(username,password,timeout=300)
			super(username,password,"https://api.five9.com/wssupervisor/SupervisorWebService?wsdl&user=",timeout)
			@last_working_timestamp = nil
		end

		def setSessionParams(options)
			@client.request :ser, :setSessionParameters, body: {viewSettings: {rollingPeriod: options[:rolling_period], shiftStart: options[:shift_start], statisticsRange: options[:statistics_range],timeZone: options[:time_zone]}}
		end

		def getStatistics(statistic_type,columns=[])
			stats = []
			response =  @client.request :getStatistics, body: {statisticType: statistic_type, columnNames: {values: { data: columns}}}
			data = response.to_array
			@last_working_timestamp = data[0][:get_statistics_response][:return][:timestamp]
			headers = data[0][:get_statistics_response][:return][:columns][:values][:data]
			data[0][:get_statistics_response][:return][:rows].each do |row|
				stats.push Hash[headers.zip row[:values][:data]]
			end
			return stats
		end

		def getStatisticsUpdate(statistic_type, object_name,long_polling_timeout=10000)
			begin
				prev_timestamp = @last_working_timestamp
				response = @client.request :ser, :getStatisticsUpdate, body: {statisticType: statistic_type, previousTimestamp: prev_timestamp, longPollingTimeout: long_polling_timeout}
				data = response.to_array
				raise TypeError, "No Updated Statistics" if data[0][:get_statistics_update_response][:return].nil?
				prev_timestamp = data[0][:get_statistics_update_response][:return][:last_timestamp]
				stats = data[0][:get_statistics_update_response][:return][:data_update]
				@last_working_timestamp = prev_timestamp
				updateStats(stats,object_name)
			rescue TypeError => e
				p e
				p e.backtrace if !e.message.include?("No Updated Statistics")
				return false
			end
			return stats
		end

		private
			def updateStats(updated_stats,object_name)
				if updated_stats.class == Hash
					@stats.each {|stat| stat[updated_stats[:column_name]] = updated_stats[:column_value] if updated_stats[:object_name] == stat[object_name]}
				elsif updated_stats.class == Array
					updated_stats.each do |updated_stat|	
						@stats.each {|stat| stat[updated_stat[:column_name]] = updated_stat[:column_value] if updated_stat[:object_name] == stat[object_name]}
					end
				end
				updated_stats
			end
	end
end