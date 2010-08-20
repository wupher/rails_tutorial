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
  
  describe "POST 'create'" do
    
    describe 'Filure' do
      
      before(:each) do
        @attr = {:name => '', :email => '', :password => '', :password_confirmation => ''}
        @user = Factory.build(:user, @attr)
        User.stub!(:new).and_return(@user)
        #it guarantee the @user MUST be call the :save function and arrange to return false
        #the first part is the test core, if :save function have not be called, an expception will be thrown out
        @user.should_receive(:save).and_return(false)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_tag("title", /sign up/i)
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe 'Success' do
      before(:each) do
        @attr = {:name => 'New User',  :email => 'user@example.com', :password => 'foobar', :password_confirmation => 'foobar'}
        @user = Factory(:user, @attr)
        User.stub!(:new).and_return(@user)
      end
      
      it "should redirect to the user show page" do
        post :create, :user  => @attr
        response.should redirect_to(user_path(@user))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
    end
  end
 
end
