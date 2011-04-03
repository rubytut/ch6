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
end
