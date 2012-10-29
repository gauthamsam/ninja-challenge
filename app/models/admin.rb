class Admin < ActiveRecord::Base
  attr_accessible :email, :firstname, :lastname, :mail_address, :password
  
  has_many :tests
end
