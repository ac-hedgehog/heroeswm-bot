# coding: utf-8
class MakeMoney
  GAME_URL = "http://www.heroeswm.ru"
  
  def self.start(login_form)
    @@browser = Watir::Browser.new :firefox
    @@browser.goto GAME_URL
    @@browser.text_field(:name => 'login').set login_form[:login]
    @@browser.text_field(:name => 'pass').set login_form[:pass]
    @@browser.input(:title => 'Войти в игру!').click 
    case @@browser.url
    when "http://www.heroeswm.ru/home.php"
      make
      "Подключение к игре прошло успешно"
    when "http://www.heroeswm.ru/login.php"
      "Неверно введён логин или пароль"
    end
  end
  
  def self.stop
    @@browser.close
  end
  
  private
  
  def self.make
  end
end
