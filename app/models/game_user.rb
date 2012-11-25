class GameUser < ActiveRecord::Base
  attr_accessible :login, :pass
end
