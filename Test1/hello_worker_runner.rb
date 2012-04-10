require 'iron_worker'
load "hello_worker.rb"
require 'yaml'
conf = YAML.load_file('config.yml')

# Create a project at hud.iron.io and enter your credentials below
#-------------------------------------------------------------------------
IronWorker.configure do |config|
  config.project_id = conf[:project_id]
  config.token = conf[:token]
end
#-------------------------------------------------------------------------

# Create and queue the worker
worker = HelloWorker.new
worker.some_param = "Passing in parameters is easy!"
worker.queue

# If you want, wait until worker complete its task
status = worker.wait_until_complete
puts "Log:"
puts worker.get_log