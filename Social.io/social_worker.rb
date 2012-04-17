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
    store_twitter(collection)
    store_facebook(collection)
  end
    
  def store_twitter(db)
    user = Twitter.user_timeline('jessepollak', count: 100)
    daily_tweets = []
    user.each do |status|
      if status.created_at.day == Time.now.day &&
      status.created_at.month == Time.now.month
         daily_tweets << status.text
      end
    end
    m_store = {"type" => "Twitter", "date" => Time.now, "tweets" => daily_tweets}
    #db.insert(m_store)
  end
    
  def store_facebook(db)
    @graph = Koala::Facebook::API.new(fb_token)
    posts = @graph.get_connection("me", "statuses")
    daily_posts = []
    posts.each do |status|
      date = Date.parse(status['updated_time'])
      if date.day == Time.now.day &&
      date.month == Time.now.month
        daily_posts << status['message']
      end
    end
    m_store = {"type" => "Facebook", "date" => Time.now, "posts" => daily_posts}
    #db_insert(m_store)
  end
  
  def init_mongo
    connection = Mongo::Connection.new(mongo_host, mongo_port)
    db = connection.db('Social-io')
    db.authenticate(mongo_user, mongo_password)
    return db['Jesse']
  end
  
  
end