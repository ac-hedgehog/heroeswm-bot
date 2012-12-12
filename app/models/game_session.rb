class GameSession < ActiveRecord::Base
  attr_accessible :user_session_id, :strategy, :winnings,
                  :bets_reps_count, :bet_field, :room_bets, :total_bets
  enum_attr :strategy, %w(zero ^third half) # порядок с учётом их приоритета
  
  COLORS = {
    '00ff00' => 'GREEN',
    '000000' => 'BLACK',
    'ff0000' => 'RED'
  }
  WINNING_COEFFICIENT = { zero: 18, third: 3, half: 2 }
  FIELD_SIZE = 38
  LOSS_PROBABILITY = { zero:   2.0  / FIELD_SIZE,
                       third:  12.0 / FIELD_SIZE,
                       half:   18.0 / FIELD_SIZE }
  BETS_REPS_RANGES = { zero: 6..9, third: 1..2, half: 1..1 }
  
  belongs_to :user_session
  
  validates :user_session_id, :strategy, :bets_reps_count,
            :room_bets, :total_bets, presence: true
  
  scope :created_at_desc, order('created_at DESC')
  scope :opened, where(winnings: nil)
  
  def update_strategy!(new_strategy, new_bets_reps_count)
    new_brc = if new_bets_reps_count.in?(BETS_REPS_RANGES[new_strategy])
      new_bets_reps_count
    else
      BETS_REPS_RANGES[new_strategy].first
    end
    update_attributes! strategy: new_strategy, bets_reps_count: new_brc
  end
  
  def choice_strategy_by(history)
    # history приходит в виде [[30, "ff0000"], [24, "000000"], [1, "ff0000"], [18, "ff0000"], [0, "00ff00"], [10, "000000"], [34, "ff0000"], [23, "ff0000"], [25, "ff0000"], [36, "ff0000"], [7, "ff0000"], [13, "000000"], [13, "000000"], [12, "ff0000"], [6, "000000"], [25, "ff0000"], [33, "000000"], [1, "ff0000"]]
    # надо ещё запрашивать текущий баланс
    update_strategy! :third, 1
  end
  
  # вероятность неудачи
  def probability_of_loss
    (1 - LOSS_PROBABILITY[strategy])**(bets_reps_count * (inc_number_of_bets + 1))
  end
  
  # максимально возможная чистая прибыль при текущей стратегии
  def max_profit
    prev_required_capital = bets_reps_count * required_capital_by(inc_number_of_bets)
    max_absolute_profit - (prev_required_capital + ending_bet)
  end
  
  # необходимый для реализации данной стратегии капитал
  def required_capital
    required_capital_by(inc_number_of_bets + 1) * bets_reps_count
  end
  
  private
  
  # величина начальной ставки
  def starting_bet
    user_session.starting_bet
  end
  
  # величина конечной ставки
  def ending_bet
    bet = starting_bet
    bet *= 2 while bet * 2 < UserSession::MAX_BET
    bet
  end
  
  # максимально возможная абсолютная прибыль при текущей стратегии
  def max_absolute_profit
    ending_bet * WINNING_COEFFICIENT[strategy]
  end
  
  # максимально возможное количество двукратных увеличений ставки
  def inc_number_of_bets
    quotient = ending_bet / starting_bet
    (Math.log(quotient) / Math.log(2)).to_i
  end
  
  # величина капитала, требуемая для возможности сделать bets_number ставок,
  # при их двукратном увеличении на каждом шагу
  def required_capital_by(bets_number)
    starting_bet * (2 ** bets_number - 1)
  end
end
