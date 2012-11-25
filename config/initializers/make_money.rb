# coding: utf-8
class MakeMoney
  GAME_URL = "http://www.heroeswm.ru"
  
  def self.start(login, pass)
    @@browser = Watir::Browser.new :firefox
    @@browser.goto GAME_URL
    @@browser.text_field(:name => 'login').set login
    @@browser.text_field(:name => 'pass').set pass
    @@browser.input(:title => 'Войти в игру!').click 
    case @@browser.url
    when "http://www.heroeswm.ru/home.php"
      make
      { status: :connected }
    when "http://www.heroeswm.ru/login.php"
      { status: :bad_login }
    end
  end
  
  def self.stop
    @@browser.close
  end
  
  private
  
  def self.make
  end
end
