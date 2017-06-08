class QuestionReminderJob < ApplicationJob
  queue_as :default

  def perform(question_id)
    question = Question.find question_id
    if question.answers.count == 0

    end
  end
end
