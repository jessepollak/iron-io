require 'iron_worker'
require 'yaml'

load 'social_worker.rb'

config_data = YAML.load_file('config.yml')

IronWorker.configure do |config|
  config.token = config_data['token']
  config.project_id = config_data['project_id']
end

worker = SocialWorker.new
worker.fb_token = config_data['fb_token']
worker.twitter_consumer_secret = config_data['twitter']['consumer_secret']
worker.twitter_consumer_key = config_data['twitter']['consumer_key']
worker.twitter_access_token = config_data['twitter']['access_token']
worker.twitter_access_secret = config_data['twitter']['access_secret']

worker.mongo_port = config_data['mongo']['port']
worker.mongo_host = config_data['mongo']['host']
worker.mongo_db_name = config_data['mongo']['db_name']
worker.mongo_user = config_data['mongo']['user']
worker.mongo_password = config_data['mongo']['password']

worker.run_local

#status = worker.wait_until_complete
#puts worker.get_log