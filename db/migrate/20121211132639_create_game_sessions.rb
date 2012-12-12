class CreateGameSessions < ActiveRecord::Migration
  def change
    create_table :game_sessions do |t|
      t.integer :user_session_id
      t.string  :strategy                     # стратегия
      t.string  :bet_field                    # поле, на которое сделана ставка
      t.integer :room_bets,       default: 0  # номер ставки
      t.integer :bets_reps_count, default: 1  # количество повторений ставки
      t.integer :total_bets,      default: 0  # общая сумма ставок
      t.integer :winnings                     # выигрыш

      t.timestamps
    end
  end
end
