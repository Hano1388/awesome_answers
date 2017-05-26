# by convention all controller classes are named: with `Controller` at the end
# of the class name.
# the generator command: rails g controller welcome
# also, the file name is important it should match the class name with snake
# case convention
# by default Rails controller inherit from `ApplicationController` which inheits
# from
class WelcomeController < ApplicationController
  # When we want to create a page or do something in our controller we define
  # public methods and we call them: Actions
  def index
    # render 'welcome/index'
    #👆 the line above is redundent in this case because the default behaviour
    # for all controller actions is to render:
    # CONTROLLER_FOLDER/ACTION.FORMAT.TEMPLATE_SYSTEM
    # CONTROLLER_FOLDER is just the controller name without the _controller
    #                   and is located inside the `views` folder
    # ACTION            in this case is `index`
    # FORMAT            default to HTML (later we can use JSON, XML or others)
  end

  def contact
    # by default this will render: /app/views/welcome/contact.html.erb
  end

  def submit
    # you have access to a variable called `params` that includes all the
    # parameters with the HTTP request, params is a Hash that is accessible with
    # strings or symbols as keys
    # if you want to share a variable from the action to the view file then you
    # must define the variable as an instance variable
    @name = params[:name] # or @name = params['name']
  end

end
