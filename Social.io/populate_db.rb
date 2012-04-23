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
friend_names = ["Emily Hayes", "Niki Sawhney", "Wes Haas"]
friend_twitters = ["emilyhayes47", "Nuggetpouch92", "weshaasIV"]
friend_facebooks = ["Emilyhayes47", "nikhil.b.sawhney", "1153625487"]
posts = graph.get_connection("me", "statuses")
user = Twitter.user_timeline('jessepollak', count: 100)
store = []

(1.month.ago.to_date..Date.today).collect do |date|
  f = posts.reject{|post| Date.parse(post['updated_time']).day != date.day || Date.parse(post['updated_time']).month != date.month}.collect {|post| post['message']}
  t = user.reject{|tweet| tweet.created_at.day != date.day || tweet.created_at.month != date.month}.collect {|tweet| tweet.text}
  store << {"name" => "Jesse Pollak", "type" => "Facebook", "date" => date.to_time, "posts" => f}
  store << {"name" => "Jesse Pollak", "type" => "Twitter", "date" => date.to_time, "tweets" => t}
end

friend_names.each_with_index do |name, i|
  posts = graph.get_connection(friend_facebooks[i], "statuses")
  user = Twitter.user_timeline(friend_twitters[i], count: 100)
  (1.month.ago.to_date..Date.today).collect do |date|
    f = posts.reject{|post| Date.parse(post['updated_time']).day != date.day || Date.parse(post['updated_time']).month != date.month}.collect {|post| post['message']}
    t = user.reject{|tweet| tweet.created_at.day != date.day || tweet.created_at.month != date.month}.collect {|tweet| tweet.text}
    store << {"name" => name, "type" => "Facebook", "date" => date.to_time, "posts" => f}
    store << {"name" => name, "type" => "Twitter", "date" => date.to_time, "tweets" => t}
  end
end

collection.insert(store)