require 'watir'
require 'rspec-expectations'
include RSpec::Matchers

def setup
  @b = Watir::Browser.new :chrome
end

def teardown
  @b.quit
end

def run
  setup
  yield
  teardown
end

run do
  # element not found error message
  # "unable to locate element, using {:title=>"Search1111", :tag_name=>"input or textarea", :type=>"(any text type)"}"

  @b.goto 'http://www.google.com'
  @b.text_field(title: 'Search1').set 'Hello World!'
  @b.button(type: 'submit').click

  # now see iframe difference
  @b.goto 'http://the-internet.herokuapp.com/iframe'
  @b.iframe(id: 'mce_0_ifr').body(id: 'tinymce1').wait_until_present
end