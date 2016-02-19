class Admin < User
  # scope :sorted, lambda { order("admins.created_at DESC")}
  scope :filter, lambda { where(:type => 'Admin')}
  # scope :search, lambda {|query|
  #   where(["name LIKE ?", "%#{query}%"])
  # }
end
