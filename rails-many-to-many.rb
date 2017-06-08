RAILS MANY TO MANY ASSOCIATION
STEPS

WE CAN SPECIFY ASSOCIATION BELOW
has_many with :through option
/////////////////////////////////////////////

SETTING MANY TO MANY RELATIONSHIP BETWEEN USERS AND QUESTIONS IN AWESOME ANSWERS PROJECT

CREATING LIKES FOR USERS AND QUESTIONS

1.
CREATING LIKES TABLE THAT HAS REFERENCES FROM BOTH USERS TABLE AND QUESTIONS TABLE
$ rails g model like user:references question:references

rails db:migrate

2.
THEN GO TO BOTH (user.rb & question.rb) MODELS AND ADD (has_many :likes, dependent: :destroy) TO BOTH

3.
NOW WE NEED TO HAVE A DIFFERNT SELECTION FOR THE QUESTIONS THAT ARE LIKED AND USER(LIKERS) BY ADDING

TO user.rb model ADD
has_many :likes, dependent: :destroy
has_many :liked_questions, through: :likes, source: :question

AND TO question.rb model ADD
has_many :likes, dependent: :destroy
has_many :likers, through: :likes, source: :user


4.
VALIDATIONS

FIRST ONE USER_ID PER A QUESTION_ID
TO like.rb model ADD
# The following validation guarantees that a user can only like a question once
validates :question_id, uniqueness: { scope: :user_id}


5.
ADDING LIKE TO TEMPLATE

FIRST : INSIDE QUESTION SHOW ADD
<%= link_to '👍', question_likes_path(@question), method: :post %>

<%= link_to '👎', question_like_path(@question, like), method: :destroy %>

SECOND : INSIDE ROUTES
resources :likes, only: [:create, :destroy]
NEST THE ABOVE ROUTE TO resources :questions

ALSO
resources :answers, only: [] do

  resources :likes, only: [:create, :destroy]
end

6.
CREATE A CONTROLLER FOR LIKES
rails g controller likes

THEN IN LIKES CONTROLLER  CREATE LIKES
def create
  question = Question.find params[:question_id]
  like = Like.new(question: question, user: current_user)
  like.save
  redirect_to question_path(question), notice: 'Thanks for liking my meaningless question!'
end

THEN MODIFY QUESTION SHOW AND ADD
(<#%= pluralize @question.likes.count, 'like' %>)

    AND THEN MODIFY LIKES CONTROLLER
    def create
      question = Question.find params[:question_id]
      like = Like.new(question: question, user: current_user)
      if like.save
        flash[:notice] = 'Thanks for liking'
      else
        flash[:alert] = like.errors.full_messages.join(', ')
      end
        redirect_to question_path(question)
    end

NOTE: WE CAN ADD self.errors.full_messages.join(', ') as a method to application_record.rb to be available for the whole application
def pretty_errors
  self.errors.full_messages.join(', ')
end
NOW ALL WE NEED, JUST TO CALL (pretty_errors) WHENEVER WE NEED IT

7.
ADDING UNLIKE

question show
    <% like = @question.likes.find_by(user: current_user) %>
    <% if like %>
        <%= link_to '👎', question_like_path(@question, like), method: :delete %>
    <% else %>
      <%= link_to '👍', question_likes_path(@question), method: :post %>
    <% end %>

likes controller

    def destroy
      like = Like.find params[:id]
      if like.destroy
        flash[:notice] = '🤒'
      else
        flash[:alert] = like.pretty_errors
      end
      redirect_to question_path(like.question)
    end

///////////////////////////////////////////////////////////

8.
ADDING FUNCTIONALITY SO THAT ONLY PEOPLE THAT SIGNED IN CAN LIKE
TO LIKES CONTROLLER
before_action :authenticate_user!

THEN TO QUESTION SHOW
<% if user_signed_in? && can?(:like, @question) %>
  <% if like %>
      <%= link_to '👎', question_like_path(@question, like), method: :delete %>
  <% else %>
    <%= link_to '👍', question_likes_path(@question), method: :post %>
  <% end %>
<% end %>

(<%= pluralize @question.likes.count, 'like' %>)

THEN TO ABILITY
    can :like, Question do |question|
      question.user != user
    end
    cannot :like, Question do |question|
      question.user == user
    end

THEN TO LIKES CONTROLLER
MODIFY CREATE ACTION
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

///////////////////////////////////////
9.
REFACTORING
IN QUESTIONS CONTROLLER ADD
@like = @question.likes.find_by(user: current_user)
TO SHOW ACTION TO GET RID OF
# (<% like = @question.likes.find_by(user: current_user) %>)
IN QUESTION SHOW

////////////////////////////////
10.
SHOWING ALL THE QUESTIONS THAT USERS LIKED

FIRST : IN ROUTES
    to resources :users nest
    resources :users, only: [:new, :create] do
      # create routes
      # /user/:user_id/liked_questions
      get 'liked_questions', to: 'questions#index'
    end

SECOND : IN QUESTIONS CONTROLLER CHANGE INDEX ACTION
    def index
      @user = User.find_by(id: params[:user_id])
      if @user
        @questions = @user.liked_questions.order(created_at: :desc)
      else
        @questions = Question.recent(30)
      end
    end


THEN ADD THIS LINK TO APPLICATION VIEWS
  <#%= link_to 'My Liked Questions', user_liked_questions_path(current_user) %>


# ///////////////////////////////////////

ADDING FONT AWESOME TO MY PROJECT

GO TO (https://github.com/bokmann/font-awesome-rails) AND SEE THE INSTRUCTIONS THERE

gem "font-awesome-rails"

bundle

ADD THE FOLLOWING LINE TO assets/stylesheet/application.css
*= require font-awesome
under ( *= require bootstrap_and_overrides)




















#
