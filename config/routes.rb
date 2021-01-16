Rails.application.routes.draw do
  get 'person/index'
  root 'person#index'
  post 'person/import_data'
end
