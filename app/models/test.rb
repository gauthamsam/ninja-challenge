class Test < ActiveRecord::Base
  attr_accessible :admin_id, :end_date, :max_score, :name, :start_date
  
  has_one :admin
  has_many :test_questions
end
