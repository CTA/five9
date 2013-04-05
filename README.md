# Five9

This RubyGem is a ruby integration for the five9 API. Currently, it is only partly integrated with the statistics API. The end goal is to have a full integration.

## Installation

Add this line to your application's Gemfile:

    gem 'five9'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install five9

## Usage

In order to use this you will have to have an active account with [This link](www.five9.com).
	
	agent_stats = Five9::AgentStats.new("exampleuser","examplepassword","https://api.five9.com/wssupervisor/SupervisorWebService?wsdl&user=exampleuser")
	agent_stats.setSessionParams(session={rolling_period: "Today", shift_start: 25200000, statistics_range: "CurrentDay", time_zone: -21600000}) //the numbers are in milliseconds.
	stats = a.getStatistics(["Total Calls","Avg Handle Time"])
	updated_stats = a.getStatisticsUpdate


For more details check out [Five9's API](http://www.five9.com/for_developers/call-center-cloud-computing.htm) for more details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
