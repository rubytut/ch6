class Micropost < ActiveRecord::Base
  # Failing to define accessble attributes means that anyone
  # could change any aspect of a micropost object simpy by 
  # using command-line client to issue malicious request.
  # In the case of the Micropost model, there is only one 
  # attribute that needs to be editable through the web, namely,
  # to content attribute.
  attr_accessible :content

  belongs_to :user

  # To get the ordering test to pass, we user a Rails facility called 
  # default_scope with an :order parameter.
  default_scope :order => 'microposts.created_at DESC'
end
