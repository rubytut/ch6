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

  # Which attributes can be modified by outside users
  # (such as users submiting requests with web browsers)
  attr_accessible :name, :email

  # validate the attributes before accepting them
  validates :name,  :presence => true
                    :length => { :maximum => 50 }

  validates :email, :presence => true

  # some email validation tests
  it "should accept valid email addresses" do
    # the '%w' marker will create an array of stings
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email adresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |adresses|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end



end




