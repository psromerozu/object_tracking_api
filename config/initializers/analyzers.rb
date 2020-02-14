require "tracker"

SCREENSHOT_PATH  ="#{Rails.root}/public/screenshots"
TRADEMARKS_PATH  ="#{Rails.root}/public/tracker/clients"
LOG_FILE_PATH ="#{Rails.root}/log/track_api.log"
API_FQDN = "http://tracker.pci.easysol.net"
apikey = []

if Rails.env.production?
	PSQLSCHEMASUFFIX ="pci"
else
	PSQLSCHEMASUFFIX ="pcidev"
end
#create html & screenshots directories if they do not exist
FileUtils.mkdir_p SCREENSHOT_PATH rescue nil

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
Ttracker = Tracker.new

