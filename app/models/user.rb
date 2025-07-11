class User < ApplicationRecord
  has_many :user_entries, dependent: :destroy

  enum role: { normal: 0, manager: 1, admin: 2 }
  attr_readonly   :role
  attr_accessor   :remember_token, :reset_token

  before_save   { self.email.downcase! }
  validates   :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
                      #URI::MailTo::EMAIL_REGEXP
  validates   :email, presence: true, length: { maximum: 255 }, 
          format: { with: VALID_EMAIL_REGEX },
          uniqueness: true
  has_secure_password
  validates   :password, presence: true, length: { minimum: 6 }, allow_nil: true

  #Handle making tokens and digests
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def remember
    self.remember_token = User.new_token
    update_columns(remember_digest: User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_columns(remember_digest: nil)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def can_change?(object)
    if object.class == UserEntry
      return admin? || id == object.user_id
    elsif object.class == User
      return self != object && (admin? || manager?)
    else
      return false
    end
  end

end
