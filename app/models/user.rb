require 'digest'
# == Schema Information
# Schema version: 20110403092218
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base

  # We introduce a virtal ( it won't be stored in database)
  # for the password attribute. The password attribute will 
  # not ever be written to the db, but will exist only in
  # memory for use in performing the password confirmation 
  # step and the encryption step.
  attr_accessor :password

  # Which attributes can be modified by outside users
  # (such as users submiting requests with web browsers)
  attr_accessible :name, :email, :password, :password_confirmation

  # association with Micropost and Relationship model...
  # Because the microposts table has a user_id attribute to 
  # identify the user. An id used in this manner to connect
  # two database tables is known as a foreign key, and when
  # the foreign key for a User model object is user_id,
  # Rails can infer the association automatically: by default,
  # Rails expacts a foreign key of the form <class>_id, where
  # <class> is the lower-cas version of the class name. In the
  # present case, although we are still dealing with users,
  # they are now identified with the foreign key follower_id,
  # so we have to tell that to Rails as shown below.
  has_many :microposts, :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id",
                            :dependent => :destroy


  # validate the attributes before accepting them
  validates :name,  :presence => true,
                    :length => { :maximum => 50 }
  
  email_regexp = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence   => true,
                    :format     => { :with =>email_regexp },
		    :uniqueness => { :case_sensitive => false }


  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  # Register callback function to encrypt the password
  # before it will be saved to database.
  before_save :encrypt_password

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
    # Method implicitly handles password mismatch case, since in that case
    # we reach the end of the method, which automatically returns nil.
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def feed
    # This is preliminary. See Chapter 12 for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  private
    def encrypt_password
      # 'new_record?' returns true if the object
      # has not yet been saved to the database.
      #
      # Since the salt is a unique identifier for each user,
      # we don't want it to change every time the user is updated,
      # and by including new_record? we ensure that the salt is 
      # only created once, when the user is first created.
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end











