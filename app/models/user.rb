class User < ApplicationRecord
  validates :username, presence: true
  validates :email, presence: true
  has_secure_password
  validates :password, presence: true
  has_many :articles
end
