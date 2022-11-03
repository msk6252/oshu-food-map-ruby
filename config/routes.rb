Rails.application.routes.draw do
  root 'shops#index'
  devise_for :admin
  get '/admin' => redirect('/admin/sign_in')

  get '/contact', to: 'contacts#index'

  get '/newer', to: 'shops#newer'
  get '/nearby', to: 'shops#nearby'
  get '/anxious', to: 'shops#anxious'

  get '/shops/:id', to: 'shops#show'
  get '/search', to: 'shops#search'
  get '/result', to: 'shops#result'

  get '/campaigns', to: 'campaigns#index'

  namespace :admin do
    resources :shops
    patch 'shops/:id/revival', to: '/admin/shops#revival'
  end

  get '/shops/nearbyshop', to: 'shops#get_nearby_shops' 

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
