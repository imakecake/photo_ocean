class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { email.downcase! } # берет переменную экземпляра, применяет к ней downcase сохраняя изменения в той же переменной
  validates :name, presence: true, length: {maximum:45}
  #VALID_EMAIL_REGEX = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ # Device?
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, # требование не пустого поля
                    length: {maximum:255},  # ограничение длины в 255 символов (максимум для varchar в БД)
                    format: { with: VALID_EMAIL_REGEX }, # соответствие регулярке
                    uniqueness: { case_sensitive: false } # не чувствительное к регистру требование уникальности email 
           
  has_secure_password
  #validates :password, length: {minimum: 6}
  validates :password, presence: true, length: {minimum: 6}, allow_blank: true
  
  # Возвращает дайджест для указанной строки.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? # тернарный оператор
            BCrypt::Engine::MIN_COST :
            BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Возвращает случайный токен
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Запоминает пользователя в базе данных для использования в постоянных сеансах
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Возвращает true, если указанный токен соответствует дайджесту
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Забывает пользователя
  def forget
    update_attribute(:remember_digest, nil)
  end
end
