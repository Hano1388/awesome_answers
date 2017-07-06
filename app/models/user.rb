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
                    format: VALID_EMAIL_REGEX,
                    unless: :from_omniauth?

  before_validation :downcase_email

  has_many :questions, dependent: :nullify

  has_many :likes, dependent: :destroy
  has_many :liked_questions, through: :likes, source: :question

  has_many :votes, dependent: :destroy
  has_many :voted_questions, through: :votes, source: :question

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  # You can the .send method to call private methods
  # This should avoided in code, but useful in a pinch when
  # when working in the console. It can also be
  # used to dynamically call a method from a string.
  # u = User.last
  # u.send(:generate_api_key)
  def downcase_email
    # self.email.downcase! if email.present?
    self.email&.downcase!
  end

  def generate_api_key

    loop do
      # SecureRandom.hex(32) will generate a 32 byte
      # string of random hex characters
      self.api_key = SecureRandom.hex(32)
      # We then check that no user already posses that
      # api_key. If no user has that key, exit the loop.
      break unless User.exists?(api_key: api_key)
    end
  end

  # serialize :omniauth_raw_data means that when ActiveRecord writes to
  # this column it will transform an object into a string.
  # When we read that column, it will transform the string back into the original
  # object.
  serialize :oath_raw_data

  def self.create_from_omniauth(omniauth_data)
    full_name = omniauth_data["info"]["name"].split
    User.create(
      uid: omniauth_data["uid"],
      provider: omniauth_data["provider"],
      first_name: full_name.first,
      last_name: full_name.last,
      oath_token: omniauth_data["credentials"]["token"],
      oath_secret: omniauth_data["credentials"]["secret"],
      oath_raw_data: omniauth_data,
      password: SecureRandom.hex(32)
    )
  end

  def self.find_from_omniauth(omniauth_data)
    User.find_by(provider: omniauth_data["provider"], uid: omniauth_data["uid"])
  end

  private
  def from_omniauth?
    uid.present? && provider.present?
  end

end
