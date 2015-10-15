require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { create(:user) }

  describe "GET index" do
    context "when the user is signed in" do
      before { sign_in user }

      it "routes them to home_controller#index" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context "when the user is not signed in" do
      it "routes them to the sign in page" do
        get :index
        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end

  describe "GET get_tweet_from_user" do
    context "when user is signed in" do
      let(:twitter_user) { "some_twitter_user" }
      let(:twitter_double) { double("tweets") }

      before do
        sign_in user
        allow(WebServices::Twitter).to receive(:new).and_return(twitter_double)
        allow(twitter_double).to receive(:get_tweets_from).with(user: twitter_user).and_return(
          [{time: "10/31/2002 02:02AM", text: "first"}, {time: "01/02/2005 01:04PM", text: "second"}]
        )
      end

      it "returns the tweets for that user" do
        get :get_tweet_from_user, user: twitter_user

        expect(JSON.parse(response.body)).to eq([
          {"time" => "10/31/2002 02:02AM", "text" => "first"},
          {"time" => "01/02/2005 01:04PM", "text" => "second"}
        ])
      end
    end

    context "when the user is not signed in" do
      it "routes them to the sign in page" do
        get :get_tweet_from_user
        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end
