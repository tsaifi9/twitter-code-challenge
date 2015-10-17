module TwitterStubber 
  def stub_twitter_user_search(user: "user-exists", results: nil)
    results ||= [
      {time: "10/31/2002 02:02AM", text: "first"},
      {time: "01/02/2005 01:04PM", text: "second"}
    ]
    allow_any_instance_of(WebServices::Twitter).to receive(:get_tweets_from).with(user: user).and_return(results)
  end
end