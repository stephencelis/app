require 'test/unit'
require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'mocha'
require 'erb'

# Mock!
module Rails
  def self.root
    self
  end
  def self.join(*args)
    args.shift # No "config" dir, OK?
    File.expand_path File.join(File.dirname(__FILE__), "fixtures", *args)
  end
  def self.env
    "development"
  end
end

# And load!
require 'app'

class AppTest < ActiveSupport::TestCase
  test "should access many ways" do
    assert_equal "Welcome!", App.config["welcome_message"]
    assert_equal "Welcome!", App.config("welcome_message")
    assert_equal "Welcome!", App["welcome_message"]
    assert_equal "Welcome!", App.welcome_message

    assert_equal "testapi", App.config["apis"]["braintree"][:login]
    assert_equal "testapi", App.config("apis", "braintree", :login)
    assert_equal "testapi", App["apis", "braintree", :login]
    assert_equal "testapi", App.apis("braintree", :login)
  end

  test "should parse ERB" do
    assert_instance_of Time, App.loaded_at
  end

  test "should accept boolean keys" do
    assert !App.process_payments?
  end

  test "should infer App.name" do
    File.stubs(:basename).returns "root"
    assert_equal "root", App.to_s
  end

  test "should namespace configs" do
    assert_instance_of Module, App::Authenticate
    assert_equal "frobozz", App::Authenticate["Stephen"]
  end

  test "should nest multiple levels of configs" do
    assert_instance_of Module, App::Authenticate::Basic::Config
    assert_equal :basic, App::Authenticate::Basic::Config.authentication_type
  end

  test "should be frozen" do
    assert_raise(TypeError) { App.config["loaded_at"] = Time.now }
  end
end
