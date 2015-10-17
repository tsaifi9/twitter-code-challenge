var UserLookup = React.createClass({
  getInitialState: function() {
    return { tweets: [] };
  },

  lookupUser:function(user) {
    $.get("get_tweet_from_user", {user: user} )
    .done(function(tweets) {
      this.setState({tweets: tweets});
    }.bind(this))
    .fail(function(jqXHR, textStatus, errorThrown) {
      this.setState({tweets: [{text: "an unknown error has occurred"}]});
    }.bind(this))
  },

  render: function() {
    return (
      <div>
        <UserSearchBar lookupUser={this.lookupUser}/>        
        <Tweets tweets={this.state.tweets}/>
      </div>
    );
  }
});

var UserSearchBar = React.createClass({
  lookupUser: function(e) {
    e.preventDefault();
    user = this.refs.user.getDOMNode().value;
    this.props.lookupUser(user);
  },

  render: function() {  
    return (
      <form>
        <input ref="user" id="user" type="text" placeholder="Search for Twitter User" />
        <button onClick={this.lookupUser}>Search</button>
      </form>
    )
  }
});

var Tweets = React.createClass({
  render: function() {  
    return (
      <div id="tweets">
        {this.props.tweets.map(function(tweet, index) {
          return <Tweet key={"tweet"+index} text={tweet.text} time={tweet.time}/>;
        })}
      </div>
    )
  }
});

var Tweet = React.createClass({
  render: function() {
    return (
      <div className="tweet">
        {this.props.text}
        <br />
        {this.props.time}
        <br /><br />
      </div>
    )
  }
});