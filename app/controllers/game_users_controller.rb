# coding: utf-8
class GameUsersController < ApplicationController
  def new
    @game_user = GameUser.new
  end
  
  def create
    @game_user = GameUser.where(params[:game_user]).first || GameUser.create!(params[:game_user])
    @game_status = "Всё пучком!" if @game_user
    render :new
  end
end
