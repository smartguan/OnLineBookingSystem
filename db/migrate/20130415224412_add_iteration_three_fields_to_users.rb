class AddIterationThreeFieldsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :contact_one, :string
    add_column :users, :contact_one_primary, :string
    add_column :users, :contact_one_secondary, :string
    add_column :users, :contact_two, :string
    add_column :users, :contact_two_primary, :string
    add_column :users, :contact_two_secondary, :string
    add_column :users, :gender, :string
    add_column :users, :skill, :string
    add_column :users, :extra, :string
    add_column :users, :access_code, :integer
    add_column :users, :type, :string
    remove_column :users, :admin
  end
  def down
    remove_column :users, :address
    remove_column :users, :city
    remove_column :users, :contact_one
    remove_column :users, :contact_one_primary
    remove_column :users, :contact_one_secondary
    remove_column :users, :contact_two
    remove_column :users, :contact_two_primary
    remove_column :users, :contact_two_secondary
    remove_column :users, :gender
    remove_column :users, :skill
    remove_column :users, :extra
    remove_column :users, :access_code
    remove_column :users, :type
    add_column :users, :admin, :boolean
  end
end
