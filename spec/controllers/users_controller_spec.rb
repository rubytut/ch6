require 'spec_helper'

describe UsersController do
  # have_selector test needs the render_views 
  # line since it tests the view along with the action.
  render_views

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
