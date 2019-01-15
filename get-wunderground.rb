# encoding: utf-8
#
# This one uses Weather Underground

require 'weather-underground'
require 'date'

# Can use ZIP code, airport code, lat/long, or "city, state" for location.
if ARGV.length < 1
   weather_id = "80601"
else 
   weather_id = ARGV[0]
end

begin
   wu = WeatherUnderground::Base.new
   if wu == nil
      printf "No response received.\n"
      exit
   end
   obs = wu.CurrentObservations(weather_id)
   sf = wu.SimpleForecast(weather_id)
rescue
   printf "Failed to get response.\n"
   exit
end

printf "Forecast for %s %s\n", obs.display_location[0].full, obs.display_location[0].zip
printf "%s\n", obs.observation_time

i = 0
width = 0
while i < 3 do
   if sf.days[i].conditions.length > width
      width = sf.days[i].conditions.length
   end
   i += 1
end

if obs.weather.length > width
   width = obs.weather.length
end

#printf "width %d\n", width

printf "  Now: %-#{width}s %.0f°%s, Wind %s, Humidity %s, Barometer %s %s\n", 
    obs.weather.strip.capitalize, 
    obs.temp_f, 'F',
    obs.wind_string.strip, 
    obs.relative_humidity,
    obs.pressure_in, 'in'

printf "  %s: %-#{width}s %.0f°%s - %.0f°%s\n", DateTime.parse(sf.days[0].datetime.to_s).strftime('%a'), sf.days[0].conditions.capitalize, sf.days[0].low.fahrenheit, 'F', sf.days[0].high.fahrenheit, 'F' 
printf "  %s: %-#{width}s %.0f°%s - %.0f°%s\n", DateTime.parse(sf.days[1].datetime.to_s).strftime('%a'), sf.days[1].conditions.capitalize, sf.days[1].low.fahrenheit, 'F', sf.days[1].high.fahrenheit, 'F' 
printf "  %s: %-#{width}s %.0f°%s - %.0f°%s\n", DateTime.parse(sf.days[2].datetime.to_s).strftime('%a'), sf.days[2].conditions.capitalize, sf.days[2].low.fahrenheit, 'F', sf.days[2].high.fahrenheit, 'F' 


