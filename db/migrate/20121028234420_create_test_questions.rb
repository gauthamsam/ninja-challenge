class CreateTestQuestions < ActiveRecord::Migration
  def change
    create_table :test_questions do |t|
      t.test_id :integer
      t.text :content
      t.string :choice1
      t.string :choice2
      t.string :choice3
      t.string :choice4
      t.smallint :correct_choice
      t.smallint :score

      t.timestamps
    end
  end
end
