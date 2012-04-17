require 'twitter'
require 'mongo'
require 'koala'
require 'active_support/core_ext'

config_data = YAML.load_file('config.yml')

connection = Mongo::Connection.new(config_data['mongo']['host'], config_data['mongo']['port'])
db = connection.db('Social-io')
db.authenticate(config_data['mongo']['user'], config_data['mongo']['password'])
collection = db['Jesse']
graph = Koala::Facebook::API.new(config_data['fb_token'])
posts = graph.get_connection("me", "statuses")
user = Twitter.user_timeline('jessepollak', count: 100)
store = []
(1.month.ago.to_date..Date.today).collect do |date|
  f = posts.reject{|post| Date.parse(post['updated_time']).day != date.day || Date.parse(post['updated_time']).month != date.month}.collect {|post| post['message']}
  t = user.reject{|tweet| tweet.created_at.day != date.day || tweet.created_at.month != date.month}.collect {|tweet| tweet.text}
  store << {"type" => "Facebook", "date" => date.to_time, "posts" => f}
  store << {"type" => "Twitter", "date" => date.to_time, "tweets" => t}
end
collection.insert(store)