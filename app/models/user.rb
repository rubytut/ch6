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

  private
    def encrypt_password
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      string # Only temporary implementation !
    end

end











