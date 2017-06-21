Rails.application.routes.draw do

  # /api/v1/questions

  # using the defaults: argument, we can provide a set of
  # options that will be default for every nested route.
  #  In this case, every route inside of the :api namespace,
  #  will render json by default instead of html.
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :questions, only: [:index, :show, :create, :destroy]
    end
  end

  match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]

  # get 'sessions/new'

   # when you put routes in Rails within a `namespace` all the urls/paths will be
   # prepended with `/` + the namespace so in this example all the routes defined
   # within will be prepended with `/admin`. Also when you defined `resources`
   # inside, it will look for the corresponding controllers in a subfolder that
   # matches the namespace you provided, so in this case Rails will look for
   # UsersController defined within the `admin` folder.
   namespace :admin do
     resources :users, only: :index
   end

  # resources :sessions, only: [:new, :create, :destroy]

    resources :sessions, only: [:new, :create] do
      # When you define a route with 'on: :collection' option, it skips requiring an :id
      delete :destroy, on: :collection
    end

  resources :users, only: [:new, :create] do
    # create routes
    # /user/:user_id/liked_questions
    get 'liked_questions', to: 'questions#index'
  end

  # /questions/5/answers <- POST
  # /questions/5/answers <- GET

  resources :questions do
    resources :likes, only: [:create, :destroy]
    resources :answers, only: [:create, :destroy]
    resources :votes, only: [:create, :update, :destroy]
    # adds the following nested routes
    # /questions/:question_id/answers VERB: post
    # /questions/:question_id/answers/:id VERB: delete
  end

  # giving an empty array to the only option
  #  means no routes will be created for that resources
  #  but we can still use it to create nested routes
  resources :answers, only: [] do
    # this creates the routes
    # /answers/:answer_id/likes VERB: post
    # /answers/:answer_id/likes/:id VERB: delete
    resources :likes, only: [:create, :destroy]
  end
  # resources :questions, only: [:new, :create]
  # resources :questions, except: [:edit, :update

  # get('/questions/new', { to: 'questions#new', as: :new_question })
  # post('/questions', { to: 'questions#create', as: :questions })
  # get('/questions/:id', { to: 'questions#show', as: :question })
  # get('/questions', { to: 'questions#index' })
  # get('/questions/:id/edit', { to: 'questions#edit', as: :edit_question })
  # patch('/questions/:id', { to: 'questions#update' })
  # delete('/questions/:id', { to: 'questions#destroy' })

  # the order in the routes.rb file is important, it's basically first come
  # first served which means the first URL that matches your request will be the
  # one that will get used.

  get('/contact', { to: 'welcome#contact' })

  post('/contact_submit', { to: 'welcome#submit' })

  # in the line below ð we're defining a route that says: when we receive a GET
  # (http) requests with URL (from HTTP as well) that is `/` then handle that
  # request in the `WelcomeController` using the `index` action
  # the `as` option will define a route helper method that can be used in the
  # view files to auto-generate the URL portion of the route defined here.
  # you will have two methods generated: home_path and home_url. The method with
  # _path will generate a relative path (no domain name) and the mehtod with
  # _url will generate an absolute path (with domain name)
  get '/', to: 'welcome#index', as: 'home'

  # get('/', { to: 'welcome#index' })

  # DSL: Domain Specific Language. It's basically how the classes, methods and
  # blocks are defined in Ruby for a speicifc purpose (in this case defining
  # routes)

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
