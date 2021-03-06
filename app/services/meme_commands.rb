class MemeCommands
  def initialize(opts)
    @channel = opts[:channel]
  end

  attr_accessor :channel

  def akm_blade_uptime
    resp = HTTParty.get(uptime_url)

    minutes = parse_into_minutes(resp)

    puts minutes

    return (minutes / 3.75).round(2)
  end

  def fleta_blade_uptime
    resp = HTTParty.get(uptime_url)

    minutes = parse_into_minutes(resp)

    puts minutes

    return (minutes / 3.95).round(2)
  end

  def parse_into_minutes(response)
    return 0 if response == "#{channel} is offline"

    time_vals = response.body.split(",").map(&:strip)

    puts time_vals

    num = time_vals.map do |value|
      unit_and_number = value.split(" ")
      number = unit_and_number[0].to_i
      unit = unit_and_number[1]

      if unit == "hours" || unit == "hour"
        number * 60
      elsif unit == "minutes" || unit == "minute"
        number
      else
        0
      end
    end.inject(:+)
  end

  def uptime_url
    "https://beta.decapi.me/twitch/uptime/#{channel}?precision=2"
  end
end
