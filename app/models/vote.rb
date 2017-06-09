class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :question_id, uniqueness: {
    scope: :user_id,
    message: 'has already been voted by yourself'
  }

  # when validating for the presence of a boolean,
  # `validates :is_up, presence: true` is not good enough
  # It will prevent values with `false` from saving.
  # You need to use the inclusion: validations where
  # you can specify the type values that are allowed
  validates :is_up, inclusion: { in: [true, false] }

  def self.up
    where(is_up: true)
  end
  def self.down
    where(is_up: false)
  end
end
