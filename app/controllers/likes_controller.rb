class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  def create
    @like = Like.new(question: @question, user: current_user)

    if cannot? :like, @question
      like_flash :alert, "Cannot like your own question, dummy!"
    elsif @like.save
      like_flash :notice, "Thanks for liking!"
    else
      like_flash :alert, @like.pretty_errors
    end

    respond_to do |format|
      format.html { redirect_to question_path(question) }
      format.js { render }
    end
  end

  def destroy
    like = Like.find(params[:id])

    if like.destroy
      like_flash :notice, "Destroyed"
    else
      like_flash :alert, like.pretty_errors
    end
    respond_to do |format|
      format.html { redirect_to question_path(like.question) }
      format.js { render :create }
    end
  end

  private
  def find_question
    @question = Question.find(params[:question_id])
  end

  def like_flash(type, message)
    # like_flash(:alert, "Failed to save")
    if request.format.js?
      flash.now[type] = message
    else
      flash[type] = message
    end
  end
end
