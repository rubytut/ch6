require 'spec_helper'

describe User do

  # run the block before each example
  before(:each) do
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
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
    addresses.each do |address|
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


  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => ""))
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      has = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end

  end # describe 'password validations'

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      # respond_to will retrun true only if the Class 
      # has a 'encrypted_password' attribute.
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encryption password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end # describe 'has_password'

    describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
	wrong_password_user.should be_nil
      end

      it "should return nul for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
	nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
	matching_user.should == @user
      end

    end # describe 'authenticate methdo"

  end # describe 'password encryption'

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end # describe admin attribute

  describe "micropost associations" do

    before(:each) do
      @user = User.create(@attr)

      # Here we indicate that the second post was created recently, 1.hour.ago,
      # with the first post created 1.day.ago. Note how convenient the user of
      # Factory Girl is: not only can we assign the user using mass assignment
      # (since factories bypass attr_accessible), we can also set created_at
      # manually, which Active Recort won't allow us to do.
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end

    it "should destroy associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status feed" do

      it "should have a feed" do
        @user.should respond_to(:feed)
      end

      it "should include the user's microposts" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end

      it "should not include a different user's microposts" do
        mp3 = Factory(:micropost,
                      :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(mp3).should be_false
      end


    end # describe status feed

  end # describe micropost associations


end








