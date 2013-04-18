class AddInstructorIdToSections < ActiveRecord::Migration
  def change
    add_column :sections, :instructor_id, :integer
  end
end
