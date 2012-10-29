class Student < ActiveRecord::Base
  attr_accessible :email, :firstname, :grade, :lastname, :mail_address, :password, :perm_id
end
