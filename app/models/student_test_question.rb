class StudentTestQuestion < ActiveRecord::Base
  attr_accessible :question_id, :student_choice, :student_id, :student_score, :test_id
end
