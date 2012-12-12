class CreateUserSessions < ActiveRecord::Migration
  def change
    create_table :user_sessions do |t|
      t.string    :login
      t.string    :pass
      t.integer   :starting_bet, default: 125
      t.datetime  :started_at
      t.datetime  :ended_at

      t.timestamps
    end
  end
end
