class Course < ActiveRecord::Base
  belongs_to :instructor
  has_many :histories
end