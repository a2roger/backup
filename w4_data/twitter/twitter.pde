/*
 * twitter demo
 *   based off of simpletweet example code
 */

import gohai.simpletweet.*;
import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.Status;
import twitter4j.TwitterException;
import twitter4j.User;

SimpleTweet simpletweet;
ArrayList<Status> tweets;

void setup() {
  size(500, 500);

  simpletweet = initSimpleTweet();

  // search twitter for tweets with this keyword
  String kw = "#poem";
  tweets = search(kw);

  println("found " + tweets.size() + " tweets with keyword '" + kw + "'.");

  textSize(20);
  textLeading(25);
}

void draw() {
  background(0);

  int i = int(map(mouseX, 0, width, 0, tweets.size() - 1));

  // get tweet content and display
  Status current = tweets.get(i);
  String message = current.getText();
  User user = current.getUser();
  String username = user.getScreenName();

  text("@" + username + ":\n" + message, 20, 20, width - 40, height - 40);
}


SimpleTweet initSimpleTweet() {

  SimpleTweet st = new SimpleTweet(this);

  /*
   * How to set up your OAuth keys and tokens:
   * 1. Create a text file called "auth_twitter.json" that looks like this:
   *
   *      {
   *       "ConsumerKey" : "", 
   *       "ConsumerSecret" : "",
   *       "AccessToken" : "",
   *       "AccessTokenSecret" : ""
   *      }
   *
   * 2. Create a new Twitter app on https://apps.twitter.com/
   *    then go to the tab "Keys and tokens".
   *
   * 3. Copy the consumer key and secret and fill the values 
   *    in your json file.
   *
   * 4. Click the button to generate the access tokens for your account
   *    copy and paste those values into the json file as well.
   */

  // make sure the path points to your "auth" file
  JSONObject auth = loadJSONObject("../../../auth_twitter.json");

  // set the OAuth keys and tokens
  st.setOAuthConsumerKey(auth.getString("ConsumerKey"));
  st.setOAuthConsumerSecret(auth.getString("ConsumerSecret"));
  st.setOAuthAccessToken(auth.getString("AccessToken"));
  st.setOAuthAccessTokenSecret(auth.getString("AccessTokenSecret")); 

  return st;
}

ArrayList<Status> search(String keyword) {

  // request 100 results
  Query query = new Query(keyword);
  query.setCount(100);

  try {
    QueryResult result = simpletweet.twitter.search(query);
    ArrayList<Status> tweets = (ArrayList)result.getTweets();
    // return an ArrayList of Status objects
    return tweets;
  } 
  catch (TwitterException e) {
    println(e.getMessage());
    return new ArrayList<Status>();
  }
}
