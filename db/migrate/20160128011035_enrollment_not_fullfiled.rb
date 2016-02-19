class EnrollmentNotFullfiled < ActiveRecord::Migration
  def change
    change_column :enrollment_requests, :is_fulfilled, :boolean, default: false
  end
end
