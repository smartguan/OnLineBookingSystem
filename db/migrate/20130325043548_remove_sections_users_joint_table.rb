class RemoveSectionsUsersJointTable < ActiveRecord::Migration
  def change
    drop_table :sections_users
  end
end
