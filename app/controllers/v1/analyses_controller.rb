class V1::AnalysesController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :verify_api_key

	def initialize
		@logflnm = "log/object_tracking_api.log"
	end

	def objectmatch
		begin
			result = Tracker.objectmatch(objectimagedata: params[:objectfile], sceneimagedata: params[:scenefile])
		rescue
			result = nil
		end
		log_request(__method__,result)
		render json: result		
	end
		
	private 
		def verify_api_key
			if API_KEY.include? params[:api_key]
				@apikey = params[:api_key]
			else
				render json: Respondent.warn("Invalid api key", Time.now) 
			end
		end
		
		def log_request(action,response)
			timestamp = "#{Time.now.to_s.split(' ')[0]},#{Time.now.to_s.split(' ')[1]}UTC"
			open(LOG_FILE_PATH, 'a') { |f| f.puts "#{timestamp},#{request.remote_ip},#{@apikey},#{action},#{response}" }
		end
end