class AddForeignKeysToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :section_id, :integer
    add_column :registrations, :user_id, :integer
  end
end
