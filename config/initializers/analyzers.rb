require "tracker"

apikey = []

#check if instance-key is in place
File.open("api-key").each do | line |
	apikey << line.split(',')[0]
end

unless apikey.size > 0
	puts "No instance key available or invalid instance key, exiting..."
	abort
else
	API_KEY = apikey
end

#initialize Visual Analyzer
#Ttracker = Tracker.new

