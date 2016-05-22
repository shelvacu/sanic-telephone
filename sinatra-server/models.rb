require 'active_record'
require 'yaml'

db_config = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(db_config)

class Room < ActiveRecord::Base
  has_many :users
  has_many :images
  belongs_to :drawing_user, class_name: "User"
end

class User < ActiveRecord::Base
  belongs_to :room
  has_many :images
  has_many :events

  def next_user
    q = room.users.where('id > ?', self.id).order(:id)
    q.first #may be nil
  end
end

class Image < ActiveRecord::Base
  belongs_to :room
  belongs_to :user
end

class Event < ActiveRecord::Base
  belongs_to :user
end
