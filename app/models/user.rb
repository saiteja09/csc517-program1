class User < ActiveRecord::Base
  has_secure_password
  normalize_attributes :name, :email

  has_many :histories
end
