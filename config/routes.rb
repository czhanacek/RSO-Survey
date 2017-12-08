Rails.application.routes.draw do
  devise_for :users

  get '/officers', to: 'officer#index'
  get '/officers/manage', to: 'officer#manage'
  post '/officers/create_officer', to: 'officer#create_officer'
  post '/officers/delete_officer', to: 'officer#delete_officer'

  get '/rsos', to: 'rso#index'
  get '/rsos/manage', to: 'rso#manage'
  get '/rsos/new', to: 'rso#new'
  get '/rsos/bulk', to: 'rso#bulk_upload'

  get '/rsos/edit/:id', to: 'rso#edit', as: "edit_rso"
  post '/rsos/create_rso', to: 'rso#create_rso'
  post '/rsos/modify_rso', to: 'rso#modify_rso'
  post '/rsos/delete_rso', to: 'rso#delete_rso'
  post '/rsos/add_keyword', to: 'rso#add_keyword'
  post '/rsos/delete_keyword', to: 'rso#delete_keyword'
  post '/rsos/add_officer', to: 'rso#add_officer'
  post '/rsos/delete_officer', to: 'rso#delete_officer'
  post '/rsos/bulk_upload', to: "rso#bulk_upload_post", as: "rso_bulk_upload"
  get '/rsos/bulk_download', to: "rso#bulk_download", as: "rso_bulk_download"

  get '/admin/manage', to: 'admin#manage'
  get '/admin', to: 'admin#index'
  get '/survey', to: 'survey#prelim1'
  get '/survey/manage', to: 'survey#manage'
  get '/survey/add_question', to: 'survey#new_question'
  get '/survey/question/:id', to: 'survey#edit_question', as: "edit_question"
  put '/survey/modify_question/:id', to: 'survey#modify_question'
  post '/survey/manage', to: 'survey#create_question'
  post '/survey/delete_question', to: 'survey#delete_question'
  post '/survey/delete_answer', to: 'survey#delete_answer'
  post '/survey/create_answer', to: 'survey#create_answer'
  get '/survey/edit_answer/:id', to: 'survey#edit_answer', as: "edit_answer"
  post '/survey/modify_answer', to: 'survey#modify_answer'
  post '/survey/submit', to: 'survey#submit'
  post '/survey/add_keyword', to: 'survey#add_keyword'
  post '/survey/edit_keyword', to: 'survey#edit_keyword'
  post '/survey/delete_keyword', to: 'survey#delete_keyword'
  get '/survey/results', to: "survey#results", as: "survey_results"
  
  post '/survey/prelim1_submit', to: "survey#prelim1_submit"
  post '/survey/prelim2_submit', to: "survey#prelim2_submit"
  get '/survey/prelim1_submit', to: redirect('/')
  get '/survey/prelim2_submit', to: redirect('/')


  get '/survey/questions/categories', to: 'category#index', as: "category_index"
  get '/survey/questions/new_category', to: 'category#new', as: "new_category"
  post '/survey/questions/new_category', to: 'category#create'
  get '/survey/questions/category/:id', to: 'category#edit', as: "edit_category"
  post '/survey/questions/category/:id', to: 'category#update'
  post '/survey/questions/delete_category', to: 'category#destroy', as: "destroy_category"

  get '/survey/questions/category_groups', to: 'category#index_category_groups', as: "category_group_index"
  get '/survey/questions/new_category_group', to: 'category#new_category_group', as: "new_category_group"
  post '/survey/questions/new_category_group', to: 'category#create_category_group'
  get '/survey/questions/category_group/:id', to: 'category#edit_category_group', as: "edit_category_group"
  post '/survey/questions/category_group/:id', to: 'category#update_category_group'
  post '/survey/questions/delete_category_group', to: 'category#destroy_category_group', as: "destroy_category_group"
  
  post '/survey/email_results', to: "survey#email_results"

  get '/survey/bulk', to: 'survey#bulk_upload'
  post '/survey/bulk_upload', to: "survey#bulk_upload_post", as: "survey_bulk_upload"
  get '/survey/bulk_download', to: "survey#bulk_download", as: "survey_bulk_download"

  root 'survey#prelim1'

end
