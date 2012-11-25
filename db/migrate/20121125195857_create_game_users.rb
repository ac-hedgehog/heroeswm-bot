class CreateGameUsers < ActiveRecord::Migration
  def change
    create_table :game_users do |t|
      t.string :login
      t.string :pass

      t.timestamps
    end
  end
end
