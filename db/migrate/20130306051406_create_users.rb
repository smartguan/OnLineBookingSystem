class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first
      t.string :last
      t.string :email
      t.string :dob
      t.string :zip
      t.integer :admin

      t.timestamps
    end
  end
end
