# coding: utf-8
class MakeMoney
  GAME_URL = "http://www.heroeswm.ru"
  HOME_URL = "#{GAME_URL}/home.php"
  ROULETTE_URL = "#{GAME_URL}/roulette.php"
  
  MIN_RATE = 125
  BEST_MIN_RATE = 156
  MAX_RATE = 5_000
  
  def self.start
    @@headless = Headless.new
    @@headless.start
    @@browser = Watir::Browser.new :firefox
  end
  
  def self.stop
    @@browser.close
    @@headless.destroy
  end
  
  def self.game_log_in
    @@browser.goto GAME_URL
    @@browser.text_field(name: 'login').set @@game_user.login
    @@browser.text_field(name: 'pass').set @@game_user.pass
    @@browser.input(title: 'Войти в игру!').click
  end
  
  def self.get_rate
    @@browser.goto ROULETTE_URL
    @@browser.a(text: /Прошлая игра/).click
    a = @@browser.a(text: /#{@@game_user.login}/)
    if a.exist?
      row = a.parent.parent
      last_rate = row.tds.first.b.text.sub(',', '').to_i
      last_prize = row.tds.last.b.text.sub(',', '').to_i
      puts "Размер последней ставки: #{last_rate}\nВыигрыш: #{last_prize}"
      rate = last_prize == 0 ? last_rate * 2 : BEST_MIN_RATE
      rate > MAX_RATE ? BEST_MIN_RATE : rate
    else
      puts "Предыдущих ставок не обнаружено"
      BEST_MIN_RATE
    end
  end
  
  def self.choice_strategy
    @@browser.a(text: /История игр/).click
    history = @@browser.table(class: 'wb').fonts.map { |font|
      [font.text.to_i, GameSession::COLORS[font.color]]
    }
    @@game_session.choice_strategy_by history
  end
  
  def self.play_in_roulette
    self.choice_strategy if @@game_session.room_bets == 0
    rate = self.get_rate
    @@browser.goto ROULETTE_URL
    @@browser.text_field(name: 'bet').set rate
    @@browser.img(title: 'RED').click
    @@browser.b(text: /Поставить!/).click
    puts "#{Time.now.strftime('%H:%M:%S')}: поставлено #{rate} на красное"
  end
  
  def self.connect_to_game(connections_number = 1)
    return false if connections_number == 0 || Time.now > @@start_time + 4.minutes
    self.game_log_in
    if @@browser.url == HOME_URL
      true
    else
      self.connect_to_game(connections_number - 1)
    end
  end
  
  def self.create_game_session
    GameSession.create! user_session_id: @@user_session.id
  end
  
  def self.get_session
    @@user_session = UserSession.at(Time.now).last
    return false unless @@user_session
    @@game_session = @@user_session.game_sessions.created_at_desc.opened.first
    @@game_session = self.create_game_session unless @@game_session
  end
  
  def self.make
    return false unless self.get_session
    sleep 2.minutes if Time.now.min % 10 == 0
    @@start_time = Time.now
    
    self.start
    if self.connect_to_game(5)
      puts "===\nПодключение к игре прошло успешно"
      self.play_in_roulette
    else
      puts "===\nНе удалось подключиться к игре"
    end
    self.stop
  end
  
  def self.browser
    @@browser
  end
end
