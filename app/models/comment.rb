# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :commentable, polymorphic: true
  validates :body, presence: true

  def display_name
    (user&.name.presence || user&.email.presence || user_name.presence || user_email)
  end
end
