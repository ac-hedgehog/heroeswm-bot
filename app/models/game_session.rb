class GameSession < ActiveRecord::Base
  attr_accessible :user_session_id, :strategy, :account,
                  :bet_field, :room_bets, :total_bets, :winnings
  enum_attr :strategy, %w(half ^third zero)
  
  belongs_to :user_session
end
