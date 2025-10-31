# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [350, 350]
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
