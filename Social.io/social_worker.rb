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
    user = Twitter.user_timeline('jessepollak', count: 100)
    user.collect! {|status| status.created_at < 1.day.ago}
    
  end
    
  def init_mongo
    connection = Mongo::Connection.new(mongo_host, mongo_port)
    db = connection.db('Social-io')
    db.authenticate(mongo_user, mongo_password)
    return db['Jesse']
  end
  
  
end