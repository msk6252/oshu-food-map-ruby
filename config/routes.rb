Rails.application.routes.draw do
  devise_for :admin
  root 'shops#index'
  get '/admin' => redirect('/admin/sign_in')

  get '/newer', to: 'shops#newer'
  get '/nearby', to: 'shops#nearby'
  get '/anxious', to: 'shops#anxious'

  get '/shops/:id', to: 'shops#show'
  get '/result', to: 'shops#result'

  namespace :admin do
    resources :shops
    patch 'shops/:id/revival', to: '/admin/shops#revival'
  end

  get '/shops/nearbyshop', to: 'shops#get_nearby_shops' 

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
