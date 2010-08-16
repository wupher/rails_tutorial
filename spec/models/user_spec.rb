require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :email => "sample@tom.com"
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
    User.create!(:name => 'tom', :email => duplicate_email)
    duplicate_email_user = User.new(:name => 'Harry', :email => duplicate_email)
    duplicate_email_user.should_not be_valid
  end
end
