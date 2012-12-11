class CreateUserSessions < ActiveRecord::Migration
  def change
    create_table :user_sessions do |t|
      t.string :login
      t.string :pass
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
