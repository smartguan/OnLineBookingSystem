class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :waitlist_place
      t.boolean :payment_received

      t.timestamps
    end
  end
end
