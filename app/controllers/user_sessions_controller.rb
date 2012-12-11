# coding: utf-8
class UserSessionsController < ApplicationController
  def edit
    @user_session = UserSession.last
  end
  
  def update
    send(params[:button])
    redirect_to edit_user_session_path(@user_session)
  end
  
  private
  
  def start
    parse_time params[:user_session], [:start_time, :end_time]
    @user_session = UserSession.find_by_login(params[:user_session][:login])
    if @user_session
      @user_session.update_attributes!(params[:user_session])
    else
      @user_session = UserSession.create!(params[:user_session])
    end
  end
  
  def slowstop
    @user_session = UserSession.last
  end
  
  def stop
    @user_session = UserSession.last
  end
  
  def parse_time(params, fields)
    fields.each { |field| params.parse_time_select! field }
    params
  end
end
