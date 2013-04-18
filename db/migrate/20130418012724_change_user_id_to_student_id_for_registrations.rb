class ChangeUserIdToStudentIdForRegistrations < ActiveRecord::Migration
  def up
    rename_column :registrations, :user_id, :student_id
  end

  def down
  end
end
