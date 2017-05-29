class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: [:destroy]
  def create
    @question = Question.find params[:question_id]
    # answer_params = params.require(:answer).permit(:body)
    @answer = Answer.new answer_params
    @answer.question = @question
    if @answer.save
      redirect_to question_path(@question), notice: "Answer Created"

    else
      render 'questions/show'
    end
  end

  def destroy
    # @answer = Answer.find params[:id]

    @question = @answer.question # or
    # @question = Question.find params[:question_id]
    @answer.destroy

    redirect_to question_path(@question), notice: 'Answer Deleted!'
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end
  def answer_params
    params.require(:answer).permit(:body)
  end
end
