# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :commentable, polymorphic: true
  validates :body, presence: true

  before_create :set_user_info

  def display_name
    (user_name.presence || user_email)
  end

  private

  def set_user_info
    return if user.blank?

    self.user_name = user.name if user_name.blank?
    self.user_email = user.email if user_email.blank?
  end
end
