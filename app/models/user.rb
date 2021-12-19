class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", 
                                  foreign_key: "follower_id", 
                                  dependent: :destroy

  has_many :passive_relationships, class_name: "Relationship", 
                                  foreign_key: "followed_id", 
                                  dependent: :destroy
  
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  attr_accessor :remember_token
  before_save :downcase_email
  mount_uploader :avatar, AvatarUploader
  
  validates :name, presence: true, length: {maximum: 50} 
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
								    format: {with: VALID_EMAIL}, 
								    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: {minimum: 6}, allow_blank: true
  validate :avatar_size

  # Возвращает дайджест для указанной строки.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
    BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Новый токен
  def User.new_token
    SecureRandom.urlsafe_base64
  end  

  # Хеширование нового токена и сохрание в бд
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end  

  def authenticated?(remember_token) 
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token) 
  end  

  def forget
    update_attribute(:remember_digest, nil)
  end

  def feed
    Post.where("user_id = ?", id)
  end  

  # Выполняет подписку на сообщения пользователя.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  
  # Отменяет подписку на сообщения пользователя.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end  
     
private  

  def downcase_email
  	self.email = email.downcase 
  end

  # Проверяет размер выгруженного изображения.
  def avatar_size
    if avatar.size > 5.megabytes
      errors.add(:avatar, "должно быть меньше 5 МБ") 
    end
  end
end



