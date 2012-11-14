class CreateStudentTests < ActiveRecord::Migration
  def change
    create_table :student_tests do |t|
      t.integer :student_id
      t.integer :test_id
      t.integer :student_score
      t.boolean :submitted

      t.timestamps
    end
  end
end
