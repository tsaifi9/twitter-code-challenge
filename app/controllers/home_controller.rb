class HomeController < ApplicationController
  before_action :authenticate_user!
  
  def index
    render component: "UserLookup"
  end

  def get_tweet_from_user
    render json: WebServices::Twitter.new.get_tweets_from(user: params[:user])
  end
end
