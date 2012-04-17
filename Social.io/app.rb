require 'sinatra'
require 'mongo'
require 'yaml'
require 'json'

config_data = YAML.load_file('config.yml')

get '/' do 
  haml :index
end

get '/data' do
  connection = Mongo::Connection.new(config_data['mongo']['host'], config_data['mongo']['port'])
  db = connection.db('Social-io')
  db.authenticate(config_data['mongo']['user'], config_data['mongo']['password'])
  collection = db['Jesse']
  facebook = collection.find("type" => "Facebook").to_a
  twitter = collection.find("type" => "Twitter").to_a
  {:facebook => facebook, :twitter => twitter}.to_json
end