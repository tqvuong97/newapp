# frozen_string_literal: true

class User < ApplicationRecord
  has_many :microposts
  has_many :comments
  validates :email, :password, :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, length: { minimum: 6 }
  has_one_attached :avatar
  enum role: { admin: 0, user: 1 }
end
