require 'watir'
require 'rspec/expectations'
require 'pry'
require 'pry-stack_explorer'
require 'pry-byebug'

include RSpec::Matchers

# run bundle exec script.rb
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

location = false
stale = false
wait = false
textarea = true

run do
  # element not found error message
  if location
    @b.goto 'http://www.google.com'
    @b.text_field(title: 'Search1').set 'Hello World!'
    @b.button(type: 'submit').click

    @b.goto 'http://the-internet.herokuapp.com/iframe'
    @b.iframe(id: 'mce_0_ifr').body(id: 'tinymce1').wait_until_present
  end
  if stale
    @b.goto 'file://c:\casnc\repos\watirdemo2\pagereload.html'
    element = @b.button(id: 'refresh')
    i = 0
    while i < 50
      begin
        element.click
      rescue
        puts 'Element stale'
      end
      i += 1
    end
  end
  if wait
    @b.goto 'http://www.google.com'
    @b.text_field(title: 'Search').set 'Hello World!'
    # binding.pry
    @b.button(type: 'submit').wait_until(5, "Oops not not there") { |el| el.present? }
    sleep 5
    @b.button(type: 'submit').when_present.click
    sleep 5
    @b.text_field(title: 'Search1').wait_until(interval: 0.5, &:present?).click
    sleep 5
  end
  if textarea
    # now you won't get a warning, it just isn't allowed
    @b.goto 'http://www.w3schools.com/tags/tryit.asp?filename=tryhtml_textarea'
    @b.iframe(id: 'iframeResult').textarea(index: 0).set 'This is a textarea'
    @b.iframe(id: 'iframeResult').text_field(index: 0).set 'This is a text field'
  end
  # TODO The text_field method can now be used to locate most HTML5 inputs - http://watir.github.io/watir-6-faq/
  # TODO Element#stale? - Returns true if a previously located element is no longer attached to DOM  - http://watir.github.io/watir-6-beta4/
  # TODO Visible Locator for Collections - http://watir.github.io/watir-6-1/


end