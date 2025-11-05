# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [350, 350]
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :avatar_content_type

  def avatar_content_type
    return unless avatar.attached? && !avatar.content_type.in?(%w[image/jpg image/jpeg image/png image/gif])

    errors.add :avatar, message: 'ファイル形式は、画像のみ指定できます。'
  end
end
