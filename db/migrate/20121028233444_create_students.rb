class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :firstname
      t.string :lastname
      t.string :perm_id
      #t.string :email
      #t.string :password
      t.integer :level_id
      t.string :mail_address

      t.timestamps
    end
  end
end
