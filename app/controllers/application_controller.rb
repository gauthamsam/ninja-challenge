class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def checkParams(required)
    required.each do |param|
      unless params.include?(param)
      return false
      end
    end
    return true
  end

  def nc_error(message="unknown error", code=99)
    status = Hash.new
    status["code"] = code
    status["message"] = message
    logger.debug "Error message: " + message
    nc_return(status)
  end

  def nc_return(status, response=nil)
    out = Hash.new
    out["status"] = status
    unless response.nil?
      out["response"] = response
    end
    respond_to do |format|
      format.html { render :json => out }
      format.json { render :json => out }
      format.xml { render :xml => out }
    end  
  end

end
