require 'rails_helper'

describe HomeController, type: :controller do
  let(:user) { create(:user) }

  describe "GET index" do
    context "when the user is signed in" do
      before { sign_in user }

      it "routes them to the react component" do
        get :index
        expect(response).to_not render_template(:index)
        expect(response).to be_success
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

      before do
        sign_in user
        stub_twitter_user_search(user: twitter_user)
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