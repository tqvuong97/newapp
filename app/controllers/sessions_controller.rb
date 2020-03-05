# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :check_login, except: :destroy
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && BCrypt::Password.new(user.password) == params[:session][:password]
      log_in user
      redirect_to root_path, notice: 'Welcome to our website'
    else
      redirect_to login_path, notice: 'Invalid account'
    end
  end

  def destroy
    log_out
    redirect_to login_path, notice: 'You are logged out'
  end

  private

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session[:user_id] = nil
  end

  def check_login
    redirect_to root_path unless session[:user_id].nil?
  end
end
