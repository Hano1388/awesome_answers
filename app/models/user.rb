class User < ApplicationRecord
  # has_secure_password is a built-in rails method taht provides user authentication features for the model its called in
  # 1. It will automatically add a presence validator for password field
  # 2. When given a password, it will generate a salt, then it will hash the salt and password combo then store the result into the database field (uses the gem 'bcrypt')
  # 3. If you skip the 'password-confirmation' field, then it won't give you a validation error for that. If you provide password-confirmation field, it will validate password against it
  # 4. The user instance gets the method 'authenticate' which will allow us to verify if a user entered the correct password. It returns the user if correct otherwise it returns 'nil'
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: {case_sensitive: false},
                    format: VALID_EMAIL_REGEX

  before_validation :downcase_email

  has_many :questions, dependent: :nullify

  has_many :likes, dependent: :destroy
  has_many :liked_questions, through: :likes, source: :question

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def downcase_email
    # self.email.downcase! if email.present?
    self.email&.downcase!
  end

end
