require 'spec_helper'

describe UsersController do
  # have_selector test needs the render_views 
  # line since it tests the view along with the action.
  render_views

  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
  end # describe GET show


  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
       get 'new'
       response.should have_selector("title", :content => "Sign up")
    end

  end

end
