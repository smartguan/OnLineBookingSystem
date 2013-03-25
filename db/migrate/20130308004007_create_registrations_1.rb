class CreateRegistrations_1 < ActiveRecord::Migration
  def change
    create_table :registrations_1 do |t|
      t.date :start_date
      t.date :end_date
      t.string :day
      t.time :start_time
      t.time :end_time
      t.string :teacher
      t.integer :enroll_cur
      t.integer :enroll_max
      t.integer :waitlist_cur
      t.integer :waitlist_max
      t.string :description

      t.timestamps
    end
  end
end
