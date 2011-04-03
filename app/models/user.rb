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
  validates :name,  :presence => true,
                    :length => { :maximum => 50 }

  validates :email, :presence => true



end




