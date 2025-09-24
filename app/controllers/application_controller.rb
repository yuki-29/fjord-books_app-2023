# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource_or_scope)
    books_path
  end

  # ログアウト後のリダイレクト先
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
