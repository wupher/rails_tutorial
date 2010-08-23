# == Schema Information
# Schema version: 20100816164003
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#
require 'digest'
class User < ActiveRecord::Base
  #password_confirmation will be created by validates_confirmation automaticly
  attr_accessible :name, :email, :password_confirmation, :password 
  attr_accessor :password
  
  before_save :encrypt_password
  
  validates_presence_of :name
  validates_length_of :name, :within => 3..50
  
  EmailRegex = /\A[\w+\_.]+@[a-z\d\_.]+\.[a-z]+\z/i
  validates_format_of :email, :with => EmailRegex
  validates_uniqueness_of :email
  
  validates_confirmation_of :password
  validates_presence_of :password
  validates_length_of :password, :within => 6..20
  
  #return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, password)
    user = User.find_by_email(email)    
    return nil if user.nil?
    return user if user.has_password?(password)
  end
  
  def remember_me!
    self.remember_token = encrypt("#{salt}--#{id}--#{Time.now.utc}")
    save_without_validation
  end
  
  private 
    def encrypt_password
      self.salt = make_salt
      self.encrypted_password = encrypt(password)
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
    def encrypt(string)
      secure_hash("#{salt}#{string}")
    end
end
