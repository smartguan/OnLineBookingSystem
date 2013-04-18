class IgnoreDateForTimeInSections < ActiveRecord::Migration
  def up
    remove_column :sections, :start_time
    add_column :sections, :start_time, :time, :ignore_date => true
    remove_column :sections, :end_time
    add_column :sections, :end_time, :time, :ignore_date => true
  end

  def down
  end
end
