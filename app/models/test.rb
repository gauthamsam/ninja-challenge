class Test < ActiveRecord::Base
  attr_accessible :admin_id, :duration, :end_date, :level_id, :max_score, :name, :start_date
  
  
  #validates :end_date,  :presence => true
  #validates :start_date, :presence => true
  #validates :level_id, :presence => true
  #validates :max_score, :presence => true
  #validates :name, :presence => true
  
 
  has_one :admin
  has_many :test_questions
end
