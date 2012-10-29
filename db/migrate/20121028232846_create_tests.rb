class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.int :max_score
      t.admin_id :integer

      t.timestamps
    end
  end
end
