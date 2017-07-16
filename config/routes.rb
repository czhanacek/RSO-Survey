Rails.application.routes.draw do
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/rso', to: 'rso#index'
  get '/rso/manage', to: 'rso#manage'

  get '/admin', to: 'admin#index'
  get '/admin/manage', to: 'admin#manage'

  get '/survey', to: 'survey#index'
  get '/survey/manage', to: 'survey#manage'
  post '/survey/manage', to: 'survey#create_question'

  root 'home#index'

end
