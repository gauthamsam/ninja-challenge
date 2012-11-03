class HomeController < ApplicationController
  def index
    @user = Admin.new
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
    
end
