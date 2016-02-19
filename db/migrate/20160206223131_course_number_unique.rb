class CourseNumberUnique < ActiveRecord::Migration
  def change
    change_column :courses, :coursenumber, :string, unique: true
    add_column :courses, :active, :boolean, default: true
    add_column :courses, :inactivation_requested, :boolean, default: false
  end
end
