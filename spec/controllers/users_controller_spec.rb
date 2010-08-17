require 'spec_helper'

describe UsersController do
  integrate_views
  
  describe "GET 'new'" do
    
    before(:each) do
      @user = Factory.build(:user)
      User.stub!(:find, @user.id).and_return(@user)
    end
    
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_tag("title", /Sign Up/)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_tag('h2>img', :class => 'gravatar')
    end
    
  end
end
