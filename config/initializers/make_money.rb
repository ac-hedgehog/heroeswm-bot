# coding: utf-8
class MakeMoney
  GAME_URL = "http://www.heroeswm.ru"
  TIME_LIMIT = 4.minutes
  
  def self.test
    start_time = Time.now
    headless = Headless.new
    headless.start
    browser = Watir::Browser.new :firefox
    game_user = GameUser.first
    
    browser.goto GAME_URL
    login_limit = 10
    while login_limit > 0 && Time.now < start_time + TIME_LIMIT
      begin
        browser.text_field(:name => 'login').set game_user.login
        browser.text_field(:name => 'pass').set game_user.pass
        browser.input(:title => 'Войти в игру!').click
        
        if browser.url == "http://www.heroeswm.ru/home.php"
          puts "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}: Авторизация прошла успешно"
          
          browser.goto "http://www.heroeswm.ru/roulette.php"
          puts "ROULETTE URL: #{browser.url}"
          
          goto_limit = 10
          while goto_limit > 0 && Time.now < start_time + TIME_LIMIT
            begin
              text = browser.div(:class, "wblight").text
              puts "Data: #{text}" if text
            rescue Timeout::Error
              goto_limit -= 1
            end
          end
        else
          puts "Авторизация не прошла успешно"
        end
        puts "\n"
        
        break
      rescue Timeout::Error
        login_limit -= 1
      end
    end
    
    browser.close
    headless.destroy
  end
  
  def self.make
    headless = Headless.new
    headless.start
    browser = Watir::Browser.new :firefox
    browser.goto GAME_URL
    game_user = GameUser.first
    browser.text_field(:name => 'login').set game_user.login
    browser.text_field(:name => 'pass').set game_user.pass
    browser.input(:title => 'Войти в игру!').click
    case browser.url
    when "http://www.heroeswm.ru/home.php"
      started = true
      status = "Подключение к игре прошло успешно"
    when "http://www.heroeswm.ru/login.php"
      status = "Неверно введён логин или пароль"
    end
    browser.goto "http://www.heroeswm.ru/roulette.php"
    text = browser.div(:class, "wblight").text
    puts "Data: \n#{browser.div(:class, "wblight").text}"
    browser.close
    headless.destroy
  end
end
