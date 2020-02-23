class Micropost < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :user
  validates :title, length: { minimum: 10 }
end
