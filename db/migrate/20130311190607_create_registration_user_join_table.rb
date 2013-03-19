class CreateRegistrationUserJoinTable < ActiveRecord::Migration
  def change
    create_table :registrations_users, :id => false do |t|
      t.integer :registration_id
      t.integer :user_id
    end
  end

end
