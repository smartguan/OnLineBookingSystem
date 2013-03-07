class ChangeAdminToBoolInUser < ActiveRecord::Migration
  def up
    remove_column :users, :admin
    add_column :users, :admin, :boolean
  end

  def down
    remove_column :users, :admin
    add_column :users, :admin, :integer
  end
end
