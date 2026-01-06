# frozen_string_literal: true

class User < ApplicationRecord

  before_destroy :archive_comments

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [150, 150]
  end

  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :nullify

  def display_name
    (name.presence || email)
  end
  
  private
 
  def archive_comments
    comments.where(user_id: id).update_all(user_name: name, user_email: email)
  end
end
