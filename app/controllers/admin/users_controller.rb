class Admin::UsersController < Admin::BaseController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    @users = User.order(created_at: :desc)
  end

  private

  def authorize_admin
    head :unauthorized unless current_user.is_admin?
  end

end
