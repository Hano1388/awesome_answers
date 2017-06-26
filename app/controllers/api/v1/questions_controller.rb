class Api::V1::QuestionsController < Api::ApplicationController
  # before_action :authenticate_user!
  before_action :find_question, only: [:show, :destroy]
  def show
    # Test if we are using current_user
    # render json: current_user

    render json: @question
  end

  def index
    @questions = Question.all.order(created_at: :DESC)
    # by default, rails will to look for an instance variable named
    # after controller and it will render (in this case as json)

    # render json: @questions

    # when using jBuilder, make sure that you do not
     # render with `render json: ...` otherwise rails will serialize
     # the model itself into json instead of using your jbuilder view
     render
  end

  def create
    question = Question.new(question_params)
    question.user = current_user

    if question.save
      render json: { id: question.id }
    else
      render json: { errors: question.errors.full_messages }
    end
  end

  def destroy

    if @question.destroy
      render json: @question
    else
      render json: { errors: @question.errors.full_messages.join(', ') }
    end

  end

  private
  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
