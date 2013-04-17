class AddSectionTypeAndLessonTypeToSections < ActiveRecord::Migration
  def change
    add_column :sections, :section_type, :string
    add_column :sections, :lesson_type, :string
  end
end
