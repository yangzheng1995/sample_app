ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
    require 'rails/test_help'
    require "minitest/reporters"
    Minitest::Reporters.use!
class ActiveSupport::TestCase
# Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical # order.
	fixtures :all
#	include ApplicationHelper


	def is_logged_in?
		!session[:user_id].nil? 
	end


	def log_in_as(user, options = {})
		password = options[:password] || 'password' 
		remember_me = options[:remember_me] || '1'
		if integration_test?
          post login_path, session: { email:       user.email,
                                      password:    password,
                                      remember_me: remember_me }
		else
			session[:user_id] = user.id 
		end
	end

	def integration_test?
		defined?(post_via_redirect)
	end

	test "feed should have the right posts" do
		michael = users(:michael)
		archer = users(:archer)
		lana = users(:lana)
        lana.microposts.each do |post_following|
			assert michael.feed.include?(post_following) 
		end
    
	michael.microposts.each do |post_self|
		assert michael.feed.include?(post_self) 
	end
        
	archer.microposts.each do |post_unfollowed|
		assert_not michael.feed.include?(post_unfollowed) 
	end
  end
      # Add more helper methods to be used by all tests here...
end