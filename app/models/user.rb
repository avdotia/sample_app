# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email,  ## attr_accesible(:name, :email)
                  :password, :password_confirmation
  has_many :microposts, :dependent => :destroy
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :presence    => true, ##validates(:name, :presence => true)
                   :length      => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }
  before_save :encrypt_password
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
    # Compare encrpted_password with the encrypted version of
    # submitted_password.
  end
  def feed
    #This is preliminary. See Chapter 12 for the full implementation.
    Micropost.where("user_id = ?", id)
  end
  
  ## EJERCICIO 1 ##
  # Copy each of the variants of the authenticate method from Listing 7.27 
  # through Listing 7.31 into your User model, and verify that they are 
  # correct by running your test suite.
  
  # 7.27 FUNCIONA!! The authenticate method with User in place of self.
 # def User.authenticate(email, submitted_password)
 #   user = find_by_email(email)
 #   return nil if user.nil?
 #   return user if user.has_password?(submitted_password)
 # end
  # 7.28 FUNCIONA!! The authenticate method with an explicit third return.
 # def self.authenticate(email, submitted_password)
 #   user = find_by_email(email)
 #   return nil if user.nil?
 #   return user if user.has_password?(submitted_password)
 #   return nil
 # end
 
  #7.29 FUNCIONA!! The authenticate method using an if statement.
 # def self.authenticate(email, submitted_password)
 #   user = find_by_email(email)
 #   if user.nil?
 #     nil
 #   elsif user.has_password?(submitted_password)
 #     user
 #   else
 #     nil
 #   end
 # end
  
  #7.30 FUNCIONA!! The authenticate method using an if statement and 
  # an implicit return.
 # def self.authenticate(email, submitted_password)
 #   user = find_by_email(email)
 #   if user.nil?
 #     nil
 #   elsif user.has_password?(submitted_password)
 #     user
 #   end
 # end
  #7.31 FUNCIONA!! The authenticate method using the ternary operator.
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    user && user.has_password?(submitted_password) ? user : nil
  end
#  def self.authenticate(email, submitted_password)
#    user = find_by_email(email)
#    return nil if user.nil?
#    return user if user.has_password?(submitted_password)
#  end
def self.authenticate_with_salt(id, cookie_salt)
  user = find_by_id(id)
  (user && user.salt == cookie_salt) ? user : nil
end
#def self.authenticate_with_salt(id, cookie_salt)
# user = find_by_id(id)
# return nil if user.nil?
# return user if user.salt == cookie_salt
#end
  private
    def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)      
    end
    def encrypt(string)
      secure_hash("#{salt}--#{string}") #Only a temporary implementation!
    end
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
