require 'iron_worker'
require 'json'

class SocialWorker < IronWorker::Base
  merge_gem 'koala'
  merge_gem 'twitter'
  merge_gem 'bson'
  merge_gem 'mongo'
  
  attr_accessor :twitter_consumer_secret, :twitter_consumer_key, 
    :twitter_access_token, :twitter_access_secret, :fb_token,
    :mongo_port, :mongo_host, :mongo_db_name, :mongo_user,
    :mongo_password
    
  def run
    collection = init_mongo
    friend_names = ["Jesse Pollak","Emily Hayes", "Niki Sawhney", "Wes Haas"]
    friend_twitters = ["jessepollak","emilyhayes47", "Nuggetpouch92", "weshaasIV"]
    friend_facebooks = ["me","Emilyhayes47", "nikhil.b.sawhney", "1153625487"]
    friend_names.zip(friend_twitters,friend_facebooks).each do |info|
      store_twitter(collection, info[1], info[0])
      store_facebook(collection, info[2], info[0])
    end
  end
    
  def store_twitter(db, twitter, name)
    user = Twitter.user_timeline(twitter, count: 100)
    daily_tweets = []
    user.each do |status|
      if status.created_at.day == Time.now.day &&
      status.created_at.month == Time.now.month
         daily_tweets << status.text
      end
    end
    m_store = {"name" => name, "type" => "Twitter", "date" => Time.now, "tweets" => daily_tweets}
    db.insert(m_store)
  end
    
  def store_facebook(db, facebook, name)
    @graph = Koala::Facebook::API.new(fb_token)
    posts = @graph.get_connection(facebook, "statuses")
    daily_posts = []
    posts.each do |status|
      date = Date.parse(status['updated_time'])
      if date.day == Time.now.day &&
      date.month == Time.now.month
        daily_posts << status['message']
      end
    end
    m_store = {"name" => name, "type" => "Facebook", "date" => Time.now, "posts" => daily_posts}
    db_insert(m_store)
  end
  
  def init_mongo
    connection = Mongo::Connection.new(mongo_host, mongo_port)
    db = connection.db('Social-io')
    db.authenticate(mongo_user, mongo_password)
    return db['Jesse']
  end
  
  
end