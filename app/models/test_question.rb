class TestQuestion < ActiveRecord::Base
  attr_accessible :choice1, :choice2, :choice3, :choice4, :content, :correct_choice, :score, :test_id
  
  belongs_to :test
end
