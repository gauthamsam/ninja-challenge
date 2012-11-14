class CreateStudentTestQuestions < ActiveRecord::Migration
  def change
    create_table :student_test_questions do |t|
      t.integer :student_id
      t.integer :test_id
      t.integer :question_id
      t.integer :student_choice
      t.integer :student_score

      t.timestamps
    end
  end
end
