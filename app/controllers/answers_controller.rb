class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: [:destroy]
  def create
    @question = Question.find params[:question_id]
    # answer_params = params.require(:answer).permit(:body)
    @answer = Answer.new answer_params
    @answer.question = @question
    respond_to do |format|
      if @answer.save
        AnswersMailer.notify_questions_owner(@answer).deliver_later
        format.html {redirect_to question_path(@question), notice: "Answer Created" }
        format.js { render :create_success }

      else
        format.html { render 'questions/show' }
        format.js { render :create_failure }
      end
    end
  end

  def destroy
    # @answer = Answer.find params[:id]

    @question = @answer.question # or
    # @question = Question.find params[:question_id]
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to question_path(@question), notice: 'Answer Deleted!' }
      format.js { render }
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end
  def answer_params
    params.require(:answer).permit(:body)
  end
end
