require "spec_helper"
require 'web_services/twitter'

describe WebServices::Twitter do
  let(:twitter) { described_class.new }
  let(:twitter_api_double) { double("twitter") }

  before { allow(::Twitter::REST::Client).to receive(:new).and_return(twitter_api_double) }

  describe "get_tweets_from" do
    let(:method_to_call) { twitter.get_tweets_from(user: "user", count: 2)}

    def tweet(created_at, message, other_field)
      OpenStruct.new(created_at: created_at, text: message, other_field: other_field)
    end

    before do 
      allow(twitter_api_double).to receive(:user_timeline).with("user", { count: 2 }).and_return([
        tweet(Time.new(2002, 10, 31, 2, 2, 2), "first", "not_used_1"),
        tweet(Time.new(2005, 1, 2, 13, 4, 2), "second", "not_used_2"),
      ]) 
    end

    context "when the user exists" do
      it "should return the tweets from the user" do
        expect(method_to_call.count).to eq(2)
        expect(method_to_call).to eq([
          {time: "10/31/2002 02:02AM", text: "first"},
          {time: "01/02/2005 01:04PM", text: "second"}
        ])
      end
    end

    describe "error conditions" do
      let(:error) { ::Twitter::Error::NotFound }

      before do
         allow(twitter_api_double).to receive(:user_timeline).with("user", { count: 2 })
          .and_raise(error)
      end

      context "when the user does not exists" do
        it "should not returns any tweets" do
          expect(method_to_call).to eq([])
        end
      end

      context "when the user is a protected account" do
        let(:error) { ::Twitter::Error::Unauthorized }

        it "should not returns any tweets" do
          expect(method_to_call).to eq([])
        end
      end

      context "when we receive an unknown error" do
        let(:error) { ::Twitter::Error::Forbidden }

        it "logs the error" do
          expect(Rails.logger).to receive(:error).with("Twitter::Error::Forbidden")
          method_to_call
        end

        it "should not returns any tweets" do
          expect(method_to_call).to eq([])
        end
      end
    end
  end
end