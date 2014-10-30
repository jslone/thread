var gtweets = [];
var btweets = [];

var gurl = 'https://threadstweets.herokuapp.com/good';
var burl = 'https://threadstweets.herokuapp.com/bad';

var addTweet = null;
var n = 0;

function regAddTweet(f) {
  addTweet = f;
}

function getTweet(good,pos) {
  var tweets = good ? gtweets : btweets;
  if(tweets.length > 0) {
    var tweet = tweets.shift();
    addTweet(tweet,pos);
    $('<p></p>').html(tweet).appendTo('#text');
  }
  else {
    var url = good ? gurl : burl;
    $.ajax({
      url: url,
      type: 'GET',
      crossDomain: true,
      dataType: 'jsonp',
      success: getTweetCallback.bind(window,good,pos),
      error: function(req,status) {
        console.log(req);
        console.log(status);
      }
    });
  }
}

function getTweetCallback(good,pos,data) {
  var tweets;
  if(good) {
    gtweets = gtweets.concat(data);
    tweets = gtweets;
  }
  else {
    btweets = btweets.concat(data);
    tweets = btweets;
  }
  if(tweets.length > 0) {
    var tweet = tweets.shift();
    $('<p></p>').html(tweet).appendTo('#text');
    addTweet(tweet,pos);
  }

}
