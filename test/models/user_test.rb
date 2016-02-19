require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Test user password
  test "User Password is Hashed" do
    # Get the user
    user = users :one

    assert_nil user.password, 'User password should not be defined'
    assert_not_nil user.password_digest, 'Password Digest should be defined'
    assert_not_equal 'password', user.password_digest, 'Password Digest should be hashed'
  end

  # Test name not nil
  test "User name cannot be nil" do
    # Create a new user
    user = User.new do |u|
      u.name = nil
      u.email = 'email'
      u.password = 'pass'
      u.type = 'Admin'
    end

    # Try to save
    begin
      user.save!
      fail 'User should not be saved'
    rescue
      assert_not user.id
    end
  end

  # Test email not nil
  test "User email cannot be nil" do
    # Create a new user
    user = User.new do |u|
      u.name = 'name'
      u.email = nil
      u.password = 'pass'
      u.type = 'Admin'
    end

    # Try to save
    begin
      user.save!
      fail 'User should not be saved'
    rescue
      assert_not user.id
    end
  end

  # Test normalizing name on save
  test "Normalize name" do
    # Create a new user
    user = User.new do |u|
      u.name = '' # Empty name should be normalized
      u.email = 'email'
      u.password = 'pass'
      u.type = 'Admin'
    end

    # Try to save
    begin
      user.save!
      fail 'User should not be saved'
    rescue
      assert_not user.id
    end
  end

  # Test normalizing email on save
  test "Normalize email" do
    # Create a new user
    user = User.new do |u|
      u.name = 'name'
      u.email = '' # Empty email should be normalized
      u.password = 'pass'
      u.type = 'Admin'
    end

    # Try to save
    begin
      user.save!
      fail 'User should not be saved'
    rescue
      assert_not user.id
    end
  end

  # Test normalizing password on save
  test "Normalize password" do
    # Create a new user
    user = User.new do |u|
      u.name = 'name'
      u.email = 'email'
      u.password = '' # Empty password should be normalized
      u.type = 'Admin'
    end

    # Try to save
    begin
      user.save!
      fail 'User should not be saved'
    rescue
      assert_not user.id
    end
  end

  # Test creating a regular user
  test "Create user" do
    # Create a new user
    user = User.new do |u|
      u.name = 'name'
      u.email = 'email'
      u.password = 'pass'
      u.type = 'Admin'
    end

    # Try to save
    begin
      user.save!
      assert user.id
    rescue
      fail 'User should have been saved'
    end
  end

  # Test creating and admin
  test "Create admin" do
    # Creat an admin
    user = Admin.create name: 'admin', email: 'email', password: 'pass'

    assert user.id
    assert_equal 'Admin', user.type
  end

  # Test creating a student
  test "Create student" do
    # Create a student
    user = Student.create name: 'admin', email: 'email', password: 'pass'

    assert user.id
    assert_equal 'Student', user.type
  end

  # Test creating an Instructor
  test "Create instructor" do
    # Create an Instructor
    user = Instructor.create name: 'admin', email: 'email', password: 'pass'

    assert user.id
    assert_equal 'Instructor', user.type
  end

  # Email must be unique
  test "Create user with conflicting email" do
    # Create first user
    User.create do |u|
      u.name = 'name'
      u.email = 'email'
      u.password = 'pass'
      u.type = 'Admin'
    end

    # Attempt to create the second user
    begin
      User.create do |u|
        u.name = 'name2'
        u.email = 'email'
        u.password = 'pass2'
        u.type = 'Admin'
      end

      fail 'user should not be created'
    rescue

    end
  end
end
