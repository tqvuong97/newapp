# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :record_not_found
  def home_page; end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  def authenticate_user!
    unless current_user
      redirect_to '/login', notice: 'Please login before accessing'
    end
  end

  def record_not_found
    render file: "#{Rails.root}/public/404", layout: true, status: :not_found
  end
end
