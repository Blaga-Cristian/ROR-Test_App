ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

module ActiveSupport
  class TestCase
    
  
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all


    def is_logged_in?
      !session[:user_id].nil?
    end

    def log_in_as(user)
      session[:user_id] = user.id
    end


    include ApplicationHelper
    # Add more helper methods to be used by all tests here...
  end
end

class ActionDispatch::IntegrationTest
  
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: {
      email: user.email,
      password: password,
      remember_me: remember_me } }
  end

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def api_safe_format(user)
    { id: user.id,
        name: user.name,
        email: user.email,
        created_at: user.created_at.iso8601(3),
        updated_at: user.updated_at.iso8601(3),
        role: user.role,
        activated: user.activated }   
  end

  def api_entry_format(entry)
    { id: entry.id,
      date: entry.date.iso8601(3),
      distance: entry.distance,
      time: entry.time,
      user_id: entry.user_id,
      created_at: entry.created_at.iso8601(3),
      updated_at: entry.updated_at.iso8601(3),
      location: entry.location }
  end

  def api_log_in_header(user)
    { 'Authorization' => "Bearer #{Api::V1::AuthToken.encode(user.id)}" }
  end

end
