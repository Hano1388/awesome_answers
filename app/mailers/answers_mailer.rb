class AnswersMailer < ApplicationMailer

  def notify_questions_owner(answer)
    # you can share instance variable with templates the same way it's done in
    # Rails controllers
    @answer   = answer
    @question = answer.question
    @user     = @question.user
    # because we have `dependent: :nullify` in our association between the user
    # and questions then we may have questions with no associated user.
    if @user
      mail(to: 'hinsul3113@gmail.com', subject: 'You got an answer to your question')
    end
  end

end
