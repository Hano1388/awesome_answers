class ApplicationMailer < ActionMailer::Base # inherits from base
  default from: 'from@example.com' # that is the email that shows as replay email when we sent a confirmation to users
  layout 'mailer' # that is in views/layouts
end

NOTE: we have mailer.html.erb and mailer.text.erb # just to send emails in html and text and we can add more extensions in case recievers devise doesn't support the format we are sending

1. TO CREATE A MAILER
$ rails g mailer answers

THAT WILL CREATE ANSWERS MAILER AND CREATE (answers_mailer) FOLDER IN VIEWS

2. CONNECTING WITH YOUR OWN GMAIL

FIRST - CREATE A FILE IN initializers create (setup_mailer.rb) with content:-
    ActionMailer::Base.smtp_settings = {
      address:              "smtp.gmail.com", # email server is gmail here
      port:                 "587",
      enable_starttls_auto: true,
      authentication:       :plain,
      user_name:            ENV["EMAIL_USER_NAME"], # reading environment  variable
      password:             ENV["EMAIL_PASSWORD"] # we will add them to gitinore
    }

NOTE: ANY FILE WE PUT IN (config/initializers) IT WILL EXCUTE ONLY ONCE WHEN THE APPLICATION LOADS

3. before creating add app_keys.rb to gitinore
/config/initializers/app_keys.rb

THEN CREATE IT IN initializers/
/initializers/app_keys.rb
THEN SET EMAIL AND PASSWORD
ENV['EMAIL_USER_NAME'] = 'answerawesome' # USER NAME OF THE ACCOUNT WE SET UP FOR OUR APP AND PASSWORD
ENV['EMAIL_PASSWORD'] = 'Sup3r$ecret'

NOTE: IT IS NICE TO HAVE app_keys.rb.example for the git instructions with the folowing content

ENV['EMAIL_USER_NAME'] = 'PUT VALUE HERE'
ENV['EMAIL_PASSWORD'] = 'PUT VALUE HERE'

4. SETTING UP EMAIL
/mailers/answers_mailer.rb  # add
def notify_questions_owner
  mail(to: 'tam@codecore.ca', subject: 'Test Email') # THE EMAIL WILL GO HERE
end

5. IN  views/answers_mailer CREATE THE FOLLOWING TWO FILES
  notify_questions_owner.html.erb
  <h1> Test Email </h1>
  notify_questions_owner.text.erb
  Test Email

6. TESING EMAIL
rails c
AnswersMailer.notify_questions_owner.deliver_now

IT WILL GO TO THE EMAIL THAT WE SPECIFIED IN (mailers/answers_mailer.rb)

7. TO SEND A PROPER EMAIL
MODIFY answers_mailer.rb
  def notify_questions_owner(answer)
    # you can share instance variable with templates the same way it's done in
    # Rails controllers
    @answer   = answer
    @question = answer.question
    @user     = @question.user
    # because we have `dependent: :nullify` in our association between the user
    # and questions then we may have questions with no associated user.
    if @user
      mail(to: 'hinsul3113@gmail.com', subject: 'You got an answer to your question')
    end
  end

  THEN MODIFY notify_questions_owner.html.erb

    <p>Hello <%= @user.first_name %>,</p>
    <p>You got answer to your questions.</p>
    <p>Question title: <%= @question.title %></p>
    <p>The Answer: <%= @answer.body %></p>
    <p>Regards,</p>
    <p>Awesome Answers Team</p>

  AND FOR THE notify_questions_owner.text.erb DO THE SAME THING JUST REMOVE TAGS

    Hello <%= @user.first_name %>,

    You got answer to your questions.

    Question title: <%= @question.title %>
    # The Answer: <%= @answer.body %>

    Regards,

    Awesome Answers Team
NOTE: TO ADD STYLING TO EMAIL WE CAN ONLY ADD INLINE STYLING

8. TO TEST IT GO rails c AGAIN AND DO THE SAME THING
rails c
answer = Answer.last
AnswersMailer.notify_questions_owner(answer).deliver_now

9 . ADD THE QUESTION URL WE CAN DO
FIRST WE NEED TO ADD THIS LINE TO config/envirenments/development.rb to last line
  config.action_mailer.default_url_options = { host: "localhost:3000" }

10. TO SEND THE ANSWER TO EMAIL AFTER BEING ADDED WE WILL ADD THE FOLLOWING LINE TO CREATE ANSWER CONTROLLER AFTER WE SAVE THE ANSWER

AnswersMailer.notify_questions_owner(@answer).deliver_now

SO NOW WHENEVER AN ANSWER CREATED, IT WILL GO TO EMAIL

11. ADD LETTER OPENER GEM TO GEMFILE to development: TO GET EMAIL RIGHT AWAY WHEN WE ARE DEVELOPING IN BROWSER

gem "letter_opener"

run bundle

THEN ADD THE FOLLOWING LINE TO  /config/environment/development.rb

config.action_mailer.delivery_method = :letter_opener


# NOTE: USE TABLES FOR INLINE STYLING EMAILS AND FOR EMAILS USE SERVICE LIKE
# sendgrid OR mailgun
