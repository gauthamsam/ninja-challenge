class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end
    
  def levels
    @levels = Level.all
    render 'students/registrations/new'
  end
end
