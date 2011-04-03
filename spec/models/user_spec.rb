require 'spec_helper'

describe User do

  # run the block before each example
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
  end

  it "should create a new instance given valid attributes" do
    # The 'create!' method raises ActiveRecord::RecordInvalid exception
    # if the creation fails. As long as the attributes are valid, it
    # won't raise any exceptions, and the test will pass.
    User.create!(@attr)
  end

  # failing test for user without a name
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))

    # same as: no_name_user.valid?.should_not == true
    no_name_user.should_not be_valid
  end

  # failing test for user without an email
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  # failing test for user name length
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end



  # some email validation tests
  it "should accept valid email addresses" do
    # the '%w' marker will create an array of stings
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email adresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |adresses|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  # email unique test
  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    User.create(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end


end
