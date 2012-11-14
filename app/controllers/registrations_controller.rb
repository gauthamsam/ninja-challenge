class RegistrationsController < Devise::RegistrationsController
  def new
    @levels = Level.all
    super
  end
  
  def create
    @levels = Level.all
    super
  end
  
end
