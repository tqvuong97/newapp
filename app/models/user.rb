class User < ApplicationRecord
  has_many :microposts
  validates :email, :password ,:name ,presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX },uniqueness: true
  validates :password,length: { minimum: 6 }
end
