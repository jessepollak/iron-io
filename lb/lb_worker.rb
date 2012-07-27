require 'iron_worker'
require 'json'
require 'nokogiri'
require 'open-uri'

class LBWorker < IronWorker::Base
  merge_gem 'bson'
  merge_gem 'mongo'
  
  attr_accessor :mongo_port, :mongo_host, :mongo_db_name, :mongo_user,
    :mongo_password
    
  def run
    db = init_mongo
    doc = Nokogiri::HTML(open('http://www.memeorandum.com/lb'))
    doc.css('.maincol tr').each_with_index do |org, i|
      name = org.css('a')[0]
      rank = org.css('.cr')[0]
      perc = org.css('.cp')[0]
      if name && rank && perc
        o = Organization.new(percentage: perc.text, rank: rank.text, name: name.text)
        db.insert(o.to_json)
      end
      break if i == 50
    end
  end
    
  def init_mongo
    connection = Mongo::Connection.new(mongo_host, mongo_port)
    db = connection.db('lb')
    db.authenticate(mongo_user, mongo_password)
    return db['data']
  end
end

class Organization 
  attr_accessor :percentage, :rank, :name, :date
  
  def initialize(options ={ })
    @percentage = options[:percentage][0...-1].to_f / 100
    @rank = options[:rank].to_i
    @name = options[:name]
    @date = Time.now.to_i / 60 / 60 / 24
  end
  
  def to_json
    {
      percentage: @percentage,
      rank: @rank,
      name: @name,
      date: @date
    }
  end
end