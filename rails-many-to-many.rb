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
















#
