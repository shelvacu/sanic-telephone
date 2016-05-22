require 'active_record'
require 'yaml'

db_config = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(db_config)

class Room < ActiveRecord::Base
  has_many :users
  has_many :images
end

class User < ActiveRecord::Base
  belongs_to :room
  has_many :images
end

class Image < ActiveRecord::Base
  belongs_to :room
  belongs_to :user
end
