class UserSession < ActiveRecord::Base
  attr_accessible :login, :pass, :start_time, :end_time
  
  has_many :game_sessions
end
