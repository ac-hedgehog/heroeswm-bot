class UserSession < ActiveRecord::Base
  attr_accessible :login, :pass, :starting_bet, :started_at, :ended_at
  
  MIN_BET = 125
  MAX_BET = 5000
  
  has_many :game_sessions
  
  validates :login, :pass, :started_at, :ended_at, presence: true
  validates :starting_bet, inclusion: MIN_BET..(MAX_BET / 2)
  
  scope :at, lambda { |time| where('started_at < ?', time)
                             .where('ended_at > ?', time) }
end
