class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  # `before_action` takes it a block or a symbol that refers to a method. The
  # block or the method will be executed just before the action. This will
  # happen within the same request/response cycle which means that defined
  # instance variables are available in the actions and consequently in the
  # associated views.
  # you can pass `only` or `except` options to the `before_action` method to
  # restrict that actions that will have `before_action` called on.
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  # the New action is usuaully used to show a form that will be used to create
  # an object which is `question` in this case
  # URL: /question/new
  # VERB: GET
  def new
    @question = Question.new
  end

  # The create action is usually used to handle form submission from the new
  # action to create a record (question in this case) in the database.
  # URL: /questions
  # VERB: POST
  def create
    @question = Question.new question_params
    # @question.user_id = session[:user_id]
    @question.user = current_user
    if @question.save
      QuestionReminderJob.set(wait: 5.days).perform_later(@question.id)
      # redirect_to question_path({ id: @question.id })
      # redirect_to question_path({ id: @question })

      # the flash message set here will be avaialble in the next
      # request/response cycle and will be deleted once used.
      flash[:notice] = 'Question created'
      redirect_to question_path(@question)
    else
      # if you want to show the flash message within the same request/response
      # cycle then you will need to use `flash.now` instead of `flash`
      flash.now[:alert] = 'Please fix errors below'

      # this will render the `app/views/questions/new.html.erb` to show the form
      # again (with errors). The default behaviour is to render `create.html.erb`
      render :new
    end
  end

  def show
    @like = @question.likes.find_by(user_id: current_user)
    @vote = @question.votes.find_by(user_id: current_user)
    @answer = Answer.new
    @answers = @question.answers.order(created_at: :desc)
  end
  def index
    if params.has_key? :user_id
      @user = User.find(params[:user_id])
      @questions = @user.liked_questions.order(created_at: :DESC)
    else
      @questions = Question.recent(30).order(created_at: :DESC)
    end
    # respond_to enables us to send different responeses depending
      # on the format of the request
    respond_to do |format|
      #  'html' is the default form. In this case, render will
      #  just show the page 'index.html.erb'
      format.html { render }
      # with every ActiveRecord object (models). there are to_json
      #  and a as_json methods that returns JSON object with every single
      #  attribute from the model. This is what 'render json: @question'
      #  will show for every question
      format.json { render json: @questions }
    end
  end

  def edit
    # head will send an empty HTTP response with a specific code, in this case
    # the code is 401 (:unauthorized), to see a list of available codes in Rails
    # you can visit: http://billpatrianakos.me/blog/2013/10/13/list-of-rails-status-code-symbols/
    head :unauthorized unless can? :edit, @question
  end

  def update
    if !(can? :update, @question)
      head :unauthorized
    elsif @question.update(question_params)
      # if you have a `redirect_to` and you'd like to specify a flash message
      # then you can just pass in the `flash` or `alert` as options to the
      # `redirect_to` instead of having a separate line. Please note that this
      # does not work with `render`
      redirect_to question_path(@question), notice: 'Question updated'
    else
      render :edit
    end
  end

  def destroy
    if can? :destroy, @question
      @question.destroy
      redirect_to questions_path, notice: 'Question deleted'
    else
      head :unauthorized
    end
  end

  private

  def question_params
    # params.require(:question).permit([:title, :body, :category_id, :tag_ids])
    # we can not permit tag as above, we need to permit it as a hash because we get more than one value from it
    params.require(:question).permit([:title, :body, :image, :category_id, { tag_ids: [] }])
  end

  def find_question
    @question = Question.find params[:id]
  end

end
