# coding: utf-8
class MakeMoney
  GAME_URL = "http://www.heroeswm.ru"
  
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
