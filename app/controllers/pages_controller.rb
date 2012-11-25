# coding: utf-8
class PagesController < ApplicationController
  def cool_ajax
    respond_to do |format|
      format.json { render json: { html: auth } }
    end
  end
  
  private
  
  def auth
    browser = Watir::Browser.new :firefox
    browser.goto "http://www.heroeswm.ru"
    browser.text_field(:name => 'login').set("Фубини")
    browser.text_field(:name => 'pass').set("Det112358")
    browser.input(:title => 'Войти в игру!').click
    result = browser.url
    browser.close
    result
  end
end
