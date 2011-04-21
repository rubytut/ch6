# Tests fo the Users controller will need instances of User model objects, 
# preferably with pre-defined values. For example the Users controller show 
# action needs an instance of the User class, so the tests for this action will 
# require that we create an @user variable somehow. 
# We'll accomplish this goal with a user 'factory', which is a convenient way 
# to define a user object and insert it into our test database.
#
# By putting the factories.rb file in the spec/ directory, we arrange for RSpec 
# to load our factories automatically whenever the test run.
#
# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@email.com"
end

