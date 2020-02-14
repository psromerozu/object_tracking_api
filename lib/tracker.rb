class Tracker
	def initialize
		#init stuff
	end

	class << self
		def objectmatch(objectimagedata: nil, sceneimagedata: nil)
			tmstart = Time.now		
			objectfile = objectimagedata['filepath']
			objectfnam = objectimagedata['filename']
			scenefile = sceneimagedata['filepath']
			scemefnam = sceneimagedata['filename']
			
			unless scenefile.nil?
				imgwidth, imgheight = FastImage.size(scenefile)
				if imgwidth <= 1280 and imgheight <= 768
					result = match(objectfilename: objectfile, scenefilename: scenefile)
					success = true
					if result['found'] == true
						message = "Match found"
					else
						message = "Match not found"
					end
				else
					success = false
					message = "image too big, maximum size is 1280x768"			
				end
			else
				success = false
				message = "invalid image"
			end
			
			if success == true 
				Respondent.info({ success: success, found: result['found'], match: result['match'], message: message, time_elapsed: "#{Time.now - tmstart} seconds" }, tmstart)		
			else
				Respondent.warn(message, tmstart)		
			end			
		end
	end
	

	private

	def match(objectfilename: nil, scenefilename: nil)
		resultm = {"found"=>false, "match"=>0}
		trckers = "#{Rails.root}/vendor/python/track-threading-1to1.py"		
		pycmd = "python #{trckers} #{objectfilename} #{scenefilename}"
		mres = `#{pycmd}`
		matchres = JSON.parse(mres)
		if matchres['found'] == true
			resultm = {"found"=>true, "match"=>matchres['match']}
		end
		resultm
	end		
end