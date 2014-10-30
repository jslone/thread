Color c = color(0,0,0,0);
Pfont f = createFont("Arial",16,false);

ArrayList<Tweets> tweets;

void setup() {
  background(c,0);
  size(600,400);
  noStroke();
  textFont(f);

  tweets = new ArrayList<Tweets>();
  regAddTweet(addTweet);
}

void draw () {
  background(c,0);
  for(int i = 0; i < tweets.size();i++) {
    Tweet tweet = tweets.get(i);
    if(tweet.update()) {
      tweets.remove(i);
      i--;
    }
    else {
      tweet.draw();
    }
  }
}

void addTweet(String tweet, PVector p) {
  tweets.add(new Tweet(tweet,p));
}


class Tweet {
  String s;
  int alpha;
  int x,y;

  Tweet(String s, PVector p) {
    this.s = s;
    x = int(p.x);
    y = int(p.y);
    alpha = 255;
  }

  boolean update() {
    alpha--;
    return alpha <= 0;
  }

  void draw() {
    fill(255,alpha);
    text(s,x,y);
  }
}
