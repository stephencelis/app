require 'test/unit'
require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'mocha'
require 'erb'

# Mock
module App
  module Rails
    def self.root
      File
    end
    def self.env
      "development"
    end
  end
end

File.stubs(:read).returns <<-YAML
---
development:
  loaded_at: <%= Time.now.iso8601 %>
  username: Stephen
  password: frobozz
  apis:
    braintree:
      :login: testapi
      :password: password1
YAML

require 'app'

class AppTest < ActiveSupport::TestCase
  test "different ways of access should return same values" do
    assert_equal "Stephen", App.config["username"]
    assert_equal "Stephen", App.config("username")
    assert_equal "Stephen", App["username"]
    assert_equal "Stephen", App.username

    assert_equal "testapi", App.config["apis"]["braintree"][:login]
    assert_equal "testapi", App.config("apis", "braintree", :login)
    assert_equal "testapi", App["apis", "braintree", :login]
    assert_equal "testapi", App.apis("braintree", :login)
  end

  test "ERB should be parsed" do
    assert_instance_of Time, App.loaded_at
  end

  test "App.name should be inferred" do
    File.stubs(:basename).returns "root"
    assert_equal "root", App.name
  end
end
