# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:postal_code, :address, :self_introduction])
  end

  private

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    books_path
  end

  # ログアウト後のリダイレクト先
  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
