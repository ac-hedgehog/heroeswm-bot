class CreateGameSessions < ActiveRecord::Migration
  def change
    create_table :game_sessions do |t|
      t.integer :user_id
      t.string  :strategy     # стратегия
      t.integer :room_stakes  # номер ставки
      t.integer :account      # счёт
      t.integer :total_stakes # общая сумма ставок
      t.integer :winnings     # выигрыш

      t.timestamps
    end
  end
end
