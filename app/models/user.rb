class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token
  before_save   :downcase_email
  before_create :create_activation_digest
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {minimum: 5, maximum: 32}
  validates :email, presence: true, length: {maximum: 32},
             format: {with: VALID_EMAIL_REGEX},
             uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 5 }, allow_blank: true

  has_many :selections, dependent: :destroy
  has_many :answers, through: :selections

  has_many :user_quizzes, dependent: :nullify
  has_many :quizzes, through: :user_quizzes
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

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

  # calculate a user's experience XP points
  def xp
    total = 0
    answers.each do |ans|
      total += (ans.value * ans.question.quiz.level)
    end
    return total
  end

  # calculate a user's particular quiz's score
  def score(quiz)
    quiz_total = 0
    answers.each do |ans|
      if ans.question.quiz == quiz
        quiz_total += ans.value
      else
        0
      end
    end
    return quiz_total
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    #UserMailer.password_reset(self).deliver_now
  end

  private 

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
