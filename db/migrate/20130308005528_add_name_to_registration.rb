class AddNameToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :name, :string
  end
end
