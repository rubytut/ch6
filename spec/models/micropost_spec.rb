require 'spec_helper'

describe Micropost do
  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "value for content" }
  end

  it "should create a new instance given valid attributes" do
    #Micropost.create!(@attr)
    # The next line uses association User<->Micropost, so the
    # user_id in microposts are updated automatically.
    @user.microposts.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      # This pattern is the canonical way to create a micropost through
      # its association with users. ( We user factory user because these
      # tests are for the Micropost model, not the User model.) 
      # When created this way, the micropost object automatically has its 
      # user_id set to the right value, which fixes issue of mass-assigment.
      @micropost = @user.microposts.create(@attr)
    end

    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end

    it "should have the right associated user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end # describe user associations

  describe "validations" do
    it "should require a user id" do
      Micropost.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      # .build is essentially equivalent to Micropost.new, except that it
      # automatically sets the micropost's user_id to @user.id
      @user.microposts.build(:content => "  ").should_not be_valid
    end

    it "should reject long content" do
      @user.microposts.build(:content => "a" * 141).should_not be_valid
    end

  end # describe validations

end
