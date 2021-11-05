Rails.application.routes.draw do
  devise_for :admin
  root 'shops#index'
  get '/admin' => redirect('/admin/sign_in')

  namespace :admin do
    resources :shops
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
