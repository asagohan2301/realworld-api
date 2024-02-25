class HomeController < ApplicationController
  def index
    render plain: "API専用のアプリケーションです。概要は https://github.com/asagohan2301/realworld-api をご覧ください。"
  end
end
