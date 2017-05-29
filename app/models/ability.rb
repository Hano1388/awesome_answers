# this file is used to define permissions (Abilities) for our application with
# the CanCanCan gem
class Ability
  include CanCan::Ability

  # you don't need to explicitly instantiate an instance of this `Ability` class
  # it will be done automatically. The main thing to keep in mind is that you
  # must have a method called `current_user` available in you application
  # controller that return the currently signed in user.
  def initialize(user)

    # we define all the rules and permissions to our applciation in this method
    # to find full details to define permissions you can visit:
    # https://github.com/CanCanCommunity/cancancan/wiki/defining-abilities


    # if the user is not signed in, current_user will return `nil` so we set it
    # to `User.new` if the user is not signed in to ease writing rules by
    # simply doing `user.id` which will return `nil` instead of raising an
    # exception
    user ||= User.new

    alias_action :create, :read, :update, :destroy, to: :crud

    if user.is_admin?
      # `:manage` option in CanCanCan gives the user the ability to do anything
      # and not just CRUD, for example, if you have other actions such as
      # publish, activate, disable...etc, :manage will include all theses
      # actions
      can :manage, :all
    end

    # this rule specifies that the user can `crud` a question if the question
    # creator (question.user) is the same as `user` who is the currently logged
    # in user. Remember that this defined the rule but you still have to enforce
    # the rule yourself by using it in your views and controllers.
    can :crud, Question do |question|
      question.user == user
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
