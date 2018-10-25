# encoding: utf-8

require 'rubygems'
require 'weather-api'
require 'table_print'

# look up WOEID via http://weather.yahoo.com; enter location by city
# name or zip and WOEID is at end of resulting page url.
# WOEID for Broomfield is 2370243
begin
  response = Weather.lookup(2370243, Weather::Units::FAHRENHEIT)
  if response == nil
    printf "No response received.\n"
    exit
  end
rescue
  printf "Failed to get response.\n"
  exit
end

tempUnits = response.units.temperature
baroUnits = response.units.pressure
windUnits = response.units.speed

printf "%s\n", response.title
#degFar = (response.condition.temp * 9) / 5 + 32

i = 0
width = 0
while i < 3 do
    if response.forecasts[i].text.length > width
        width = response.forecasts[i].text.length
    end
    i += 1
end

if response.condition.text.length > width
   width = response.condition.text
end


printf "  Now: %-#{width}s %s°%s, Wind %s%s %s, Humidity %s%%, Barometer %s @ %s%s\n", 
    response.condition.text, response.condition.temp, tempUnits, 
    response.wind.speed, windUnits, 
    response.wind.direction, 
    response.atmosphere.humidity, 
    response.atmosphere.barometer, response.atmosphere.pressure, baroUnits
printf "  %s: %-#{width}s %s°%s - %s°%s\n", response.forecasts[0].day, response.forecasts[0].text, response.forecasts[0].low, tempUnits, response.forecasts[0].high, tempUnits 
printf "  %s: %-#{width}s %s°%s - %s°%s\n", response.forecasts[1].day, response.forecasts[1].text, response.forecasts[1].low, tempUnits, response.forecasts[1].high, tempUnits
printf "  %s: %-#{width}s %s°%s - %s°%s\n", response.forecasts[2].day, response.forecasts[2].text, response.forecasts[2].low, tempUnits, response.forecasts[2].high, tempUnits

#tp.set :separator, ","
#tp.set :time_format, "%m/%d"
#tp.set :capitalize_headers, false
#tp.set :max_width, 10
#tp response.forecasts


