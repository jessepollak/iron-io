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
  names = ["Jesse Pollak", "Emily Hayes", "Niki Sawhney", "Wes Haas"]
  collection = db['Jesse']
  data = {}
  names.each do |name|
    facebook = collection.find("type" => "Facebook", "name" => name).to_a
    facebook.sort!{|x,y| x['date'] <=> y['date']}
    twitter = collection.find("type" => "Twitter", "name" => name).to_a
    twitter.sort!{|x,y| x['date'] <=> y['date']}
    data[name] = {:facebook => facebook, :twitter => twitter}
  end
  data.to_json
end