class LikesController < ApplicationController
  before_action :authenticate_user!
  def create
    question = Question.find params[:question_id]
    like = Like.new(question: question, user: current_user)
    if cannot? :like, question
      flash[:alert] = 'Can not like your own question, dummy!'
    elsif like.save
      flash[:notice] = 'Thanks for liking'
    else
      flash[:alert] = like.pretty_errors
    end
      redirect_to question_path(question)
  end

  def destroy
    like = Like.find params[:id]
    if like.destroy
      flash[:notice] = '🤒'
    else
      flash[:alert] = like.pretty_errors
    end
    redirect_to question_path(like.question)
  end
end
