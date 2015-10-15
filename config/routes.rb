Rails.application.routes.draw do
  devise_for :users
  get 'get_tweet_from_user', to: "home#get_tweet_from_user"
  root 'home#index'
end
