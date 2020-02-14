class Respondent
  #info
  def self.info(message, init_time)
    if message.present?
      { 
        response: message.merge!({ time_elapsed: Time.now - init_time }) 
      }
    else
      self.handler(:bad_request, "Empty image", init_time)
    end
  end

  #warning
  def self.warn(error, init_time)
    self.handler(:conflict, error, init_time)
  end

  #exception
  def self.error(error, init_time)
    self.handler(:internal_server_error, error, init_time)
  end

  #handler
  def self.handler(code, error, init_time)
    { 
      error: 
        { code: code, message: error.to_s, time_elapsed: Time.now - init_time } 
    }
  end
end