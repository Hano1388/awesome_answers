class Like < ApplicationRecord
  belongs_to :user
  belongs_to :question

  # The following validation guarantees that a user can only like a question once
  validates :question_id, uniqueness: { scope: :user_id, message: 'Question has already been liked by yourself'}

end
