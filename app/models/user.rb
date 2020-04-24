class User < ApplicationRecord
  before_save { self.email= email.downcase }
  validates :name, presence: true, length: {maximum:45}
  #VALID_EMAIL_REGEX = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, # требование не пустого поля
                    length: {maximum:255},  # ограничение длины в 255 символов (максимум для varchar в БД)
                    format: { with: VALID_EMAIL_REGEX }, # соответствие регулярке
                    uniqueness: { case_sensitive: false } # не чувствительное к регистру требование уникальности email 

  has_secure_password
  validates :password, length: {minimum: 6}
end
