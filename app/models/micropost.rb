class Micropost < ApplicationRecord
  belongs_to :user
  validates :title, length: { minimum: 10 }
end
