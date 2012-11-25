# coding: utf-8
class PagesController < ApplicationController
  def cool_ajax
    respond_to do |format|
      format.json { render json: { html: "Щикарно!" } }
    end
  end
end
