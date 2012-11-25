# coding: utf-8
class PagesController < ApplicationController
  def cool_ajax
    respond_to do |format|
      format.json { render json: MakeMoney::start("Фубини", "Det112358") }
    end
  end
end
