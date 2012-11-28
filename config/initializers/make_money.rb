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
  
  def self.connect_to_last_game(connections_number = 1)
    return false if connections_number == 0 || Time.now > @@start_time + 4.minutes
    print "Попытка зайти на прошлую игру."
    @@browser.goto ROULETTE_URL
    print " (#{@@browser.url})."
    links = @@browser.a(href: 'allroul.php').parent.as
    if links.last.exist?
      print "."
      links.last.click
      print "."
      if @@browser.url.include? "inforoul"
        puts " Успех."
        return true
      end
    end
    puts " Неудача."
    self.connect_to_last_game(connections_number - 1)
  end
  
  def self.get_rate
    #return BEST_MIN_RATE unless self.connect_to_last_game(5)
    @@browser.goto ROULETTE_URL
    #@@browser.a(href: 'allroul.php').parent.as.last.click
    @@browser.a(text: 'Прошлая игра').click
    puts @@browser.url
    
    a = @@browser.a(:text => /#{@@game_user.login}/)
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
  
  def self.play_in_roulette
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
  
  def self.make
    @@game_user = GameUser.last
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
