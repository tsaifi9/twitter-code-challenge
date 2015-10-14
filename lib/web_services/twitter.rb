require "twitter"

module WebServices
  class Twitter
    def initialize
      @client = ::Twitter::REST::Client.new do |config|
        config.consumer_key        = "bDOanH7vloSnwEweyerlXrM88"
        config.consumer_secret     = "vd8YqrK6YBNLpnrdVjGuPUmJQjysZV7iYX5ArERHXw8uEl8YaQ"
        config.access_token        = "3887745493-WpatjeEUS4C9rbFBgD0GqmddUBmlQNYfmhOjCk7"
        config.access_token_secret = "75FwCyeDq81fwuNiOvbRQNpBM3nsUJwf4PpeTVURDygKT"
      end
    end

    def get_tweets_from(user: , count: 25)
      @client.user_timeline(user, {count: count}).map{|t| {time: format_time(t.created_at), text: t.text} }
    rescue ::Twitter::Error::NotFound
      []
    end

    private

    def format_time(date_time)
      date_time.strftime("%m/%d/%Y %I:%M%p") 
    end
  end
end