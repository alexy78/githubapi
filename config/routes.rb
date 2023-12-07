Rails.application.routes.draw do
  root 'git_info#index'
  post 'git_info/show'
end
