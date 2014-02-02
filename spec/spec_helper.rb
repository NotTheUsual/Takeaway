require "./lib/takeaway"
require "./lib/dish"
require "./lib/order"
require "./lib/line_item"
require './lib/interface'

RSpec.configure do |config|
  # This is the thing that means it won't print out anything in the tests.
  # I hope
  original_stderr = $stderr
  original_stdout = $stdout
  config.before(:all) do 
    # Redirect stderr and stdout
    $stderr = File.new(File.join(File.dirname(__FILE__), '.', 'output.txt'), 'w')
    $stdout = File.new(File.join(File.dirname(__FILE__), '.', 'output.txt'), 'w')
  end
  config.after(:all) do 
    $stderr = original_stderr
    $stdout = original_stdout
  end
end