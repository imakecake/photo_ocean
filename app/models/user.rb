class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_one_attached :avatar # прикрепление аватара пользователю
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
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
  validates :avatar, content_type: { in: %w[image/jpeg image/jpg image/gif image/png image/bmp],
                                message: "must be a valid image format" },
                      size: { less_than: 10.megabytes,
                                message: "should be less than 10MB" }
  
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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Забывает пользователя
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Активирует учетную запись
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Посылает письмо со ссылкой на стринцу активации 
  def send_activation_email
    UserMailer.account_activation(self).deliver_now    
  end
  
  # Устанавливает атрибуты для сброса пароля.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), 
                   reset_sent_at: Time.zone.now)
  end

  # Посылает письмо со ссылкой на форму ввода нового пароля.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Возвращает true, если время для сброса пароля истекло.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Определяет прото-ленту.
  # Полная реализация приводится в разделе "Следование за пользователями".
  def feed
    Post.where("user_id = ?", id)
  end

  def display_avatar
    avatar.variant(resize_to_limit: [75, 75])
  end

  private
    
    # Создает и присваивает токен активации и его дайджест
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
