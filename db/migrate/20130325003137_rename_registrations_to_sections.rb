class RenameRegistrationsToSections < ActiveRecord::Migration
  def up
    rename_table :registrations, :sections
    rename_column :registrations_users, :registration_id, :section_id
    rename_table :registrations_users, :sections_users
  end

  def down
    rename_table :sections, :registrations
    rename_column :sections_users, :section_id, :registration_id
    rename_table :sections_users, :registrations_users
  end
end
