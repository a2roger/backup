

// https://github.com/jublo/codebird-js
var cb = new Codebird();

// keyword to search
let keyword = ''

// Twitter OAuth keys
let CONSUMER_KEY
let CONSUMER_SECRET
let TOKEN
let TOKEN_SECRET

function preload() {
  // load OAuth keys from auth file
  loadJSON("_private/auth-notmine.json", auth => {
    CONSUMER_KEY = auth.CONSUMER_KEY
    CONSUMER_SECRET = auth.CONSUMER_SECRET
    TOKEN = auth.TOKEN
    TOKEN_SECRET  = auth.TOKEN_SECRET   
  });
}

function setup() {
  createCanvas(100, 100);

  keyword = 'boring'

  createDebugWindow()

  // set OAuth keys
  cb.setConsumerKey(CONSUMER_KEY, CONSUMER_SECRET);
  cb.setToken(TOKEN, TOKEN_SECRET);

  let parameters = {
    q: keyword,
    result_type: 'recent',
    count: 50
  };

  debug('running Twitter API call ...')

  cb.__call(
    'search_tweets',
    parameters,
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

function draw() {
  background(240)
  fill(0)
  textAlign(CENTER, CENTER);  
  textSize(14);
  text(keyword, width/2, height/2)
}

function keyPressed() {
  if (key == ' ') {
  }
}






