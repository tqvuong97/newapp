class SessionsController < ApplicationController
  before_action :check_login
  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && BCrypt::Password.new(user.password) == params[:password]
      flash[:success] = "Welcome to our website"
      log_in user
      redirect_to root_path
    else
      flash[:danger] = "Invalid account"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = "You are logged out"
    redirect_to login_path
  end

  private
  def log_in user
    session[:user_id] = user.id
  end
  def log_out
    session[:user_id] = nil
  end
  def check_login
    redirect_to root_path if !session[:user_id].nil?
  end
end
