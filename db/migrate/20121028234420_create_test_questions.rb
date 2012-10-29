class CreateTestQuestions < ActiveRecord::Migration
  def change
    create_table :test_questions do |t|
      t.integer :test_id
      t.text :content
      t.string :choice1
      t.string :choice2
      t.string :choice3
      t.string :choice4
      t.integer :correct_choice
      t.integer :score

      t.timestamps
    end
  end
end
