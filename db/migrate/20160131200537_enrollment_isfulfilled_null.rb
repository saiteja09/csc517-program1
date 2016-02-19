class EnrollmentIsfulfilledNull < ActiveRecord::Migration
  def change
    change_column :enrollment_requests, :is_fulfilled, :boolean, default: false, null: true
  end
end
