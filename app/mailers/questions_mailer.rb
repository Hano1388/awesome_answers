class QuestionsMailer < ApplicationMailer
  def send_reminder(question)
    @question = question
    @user = question.user
    if @user
      mail(to: @user.email, subject: 'Question Reminder')
    end
  end
end
