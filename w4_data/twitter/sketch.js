

var consumerKey = 'jJKwYVKkqnSkbr63NpK7Vzvkx';
var consumerSecret = 'lTMfwMs7rDxz8vPcxBD7Gy5lDO8GXnlIzPw2d8xVhqa1L4xOTw';

var token = '364475473-kMBumzdzoxKZcduTwFGizG0iyMldRx1CQtcRXm2w';
var tokenSecret = 'KBjBbqUZ0of2SQZDFEqSFof7kQPpENigIh7d3BMUQyCjN';

var cb = new Codebird();

function preload() {
}

// function setup() {
//   createCanvas(500, 500)
  
//  }

function draw() {
  // background(240)
 
}

function keyPressed() {
  if (key == ' ') {
  }
}


function setup() {
  createCanvas(500, 100);

  createDebugWindow()

  // setup OAuth API
  cb.setConsumerKey(consumerKey, consumerSecret);
  cb.setToken(token, tokenSecret);

  let options = {
    q: "boring",
    result_type: 'recent',
    count: 20
  };

  cb.__call(
    "search_tweets",
    options,
    function(reply) {

      let statuses = reply.statuses;
      for (let i = 0; i < statuses.length; i++) {
        let tweet = statuses[i];
        if (!tweet.retweeted_status) {
          debug(tweet.text);
        }
      }
      // print the max_id which helps if you want to grab pages of data
      debug('max_id: ' + reply.search_metadata.max_id);

    }
  );

}






