require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :name => "Marshall Mather",
      :email => "sample@tom.com",
      :password => "Not Afraid",
      :password_confirmation => 'Not Afraid'
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
  
  it "should require a name" do
    user = User.new(:email => 'tom@tom.com',:name => '')
    user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "nami" * 50
    long_name_user = User.new(@valid_attributes.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should reject emails that are not valid format" do
    invalid_emails = ["tom",'tom@t','tom@.com']
    invalid_emails.each do |address|
      invalid_email_user = User.new(@valid_attributes.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate emails" do
    duplicate_email = "tom@tom.com"
    User.create!(@valid_attributes.merge(:name => 'tom', :email => duplicate_email))
    duplicate_email_user = User.new(:name => 'Harry', :email => duplicate_email)
    duplicate_email_user.should_not be_valid
  end
  
  describe "password validation" do
    
    it "should  require a password" do
      User.new(@valid_attributes.merge(:password => '', :password_confirmation => '')).should_not be_valid
    end
    
    it "should  require matching password confirmation" do
      User.new(@valid_attributes.merge(:password_confirmation => 'invalid')).should_not be_valid
    end
    
    it "should reject short passwords" do
      short_pwd = 'a' * 5;
      User.new(@valid_attributes.merge(:password => short_pwd, :password_confirmation => short_pwd)).should_not be_valid
    end
    
    it "should reject too long passwords" do
      long_pwd = 'a' * 21;
      User.new(@valid_attributes.merge(:password => long_pwd, :password_confirmation => long_pwd)).should_not be_valid
    end
  end #end of password validattion tests
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@valid_attributes)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it 'should set the encrypted password' do
      @user.encrypted_password.should_not be_blank
    end
    
      describe 'has_password? method' do
        it "should return true if the passwords match" do
          @user.has_password?(@valid_attributes[:password]).should be_true
        end
        
        it "should return false the passwords don't match" do
          @user.has_password?('invalid').should be_false
        end
      
      end# end of has_password? describe
      
      describe "authenticate method" do
        
        it 'should return nil on email/password missmatch' do
          wrong_pwd_user = User.authenticate(@valid_attributes[:email], 'wrong pass')
          wrong_pwd_user.should be_nil
        end
        
        it 'should return nil on email/password on no user' do
          wrong_email_user = User.authenticate('t@t.com', @valid_attributes[:password])
          wrong_email_user.should be_nil
        end
        
        it 'should return user on email/password match' do
          match_user = User.authenticate(@valid_attributes[:email], @valid_attributes[:password])
          match_user.should == @user
        end
      end
  end #end of password encrypted
  
  describe "remember me" do
    before(:each) do
      @user  = User.create!(@valid_attributes)
    end
    
    it "should have a remember token" do
      @user.should respond_to(:remember_token)
    end
    
    it "should have a remember_me! method" do
      @user.should respond_to(:remember_me!)
    end
    
    it "should set the remember token" do
      @user.remember_me!
      @user.remember_token.should_not be_nil
    end
  end
end
