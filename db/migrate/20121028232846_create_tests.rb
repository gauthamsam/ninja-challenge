class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.integer :max_score
      t.integer :admin_id
      t.integer :level_id
      t.integer :duration

      t.timestamps
    end
  end
end
