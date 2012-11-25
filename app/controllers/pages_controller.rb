# coding: utf-8
class PagesController < ApplicationController
  def make_money
    @game_status = MakeMoney::start(params[:login_form])
    render :index
  end
end
