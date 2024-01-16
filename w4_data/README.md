# Workshop 4: Data

In this workshop, we'll review different code examples that illustrate techniques to get historical, current, or real-time data that could be used as input. You'll learn about a variety of ways to access data, how to process it, and how to transform it into generative and other types of artworks.

## Goals

* Use `loadStrings` to read in lines of text and perform basic text processing.
* Use `Table` to load and index data from a CSV file.
* Use `XML` to load and search for content in a RSS feed.
* Create querystring URLs to access data.
* Use `JSONObject` to process responses from data sources.
* Learn about OAuth and APIs like Twitter's

## Resources

#### Data Sources 

Meta lists of online resources for data and data APIs.

* [Big List of Free and Open Public APIs (No Auth Needed)](https://mixedanalytics.com/blog/list-actually-free-open-no-auth-needed-apis/)

* [A collective list of free APIs for use in software and web development](https://github.com/public-apis/public-apis)

* [50 Amazing Free Data Sources You Should Know (infogram)](https://infogram.com/blog/free-data-sources/)

* [10 Great Places to Find Free Datasets for Your Next Project](https://careerfoundry.com/en/blog/data-analytics/where-to-find-free-datasets/)

* [20 Awesome Sources of Free Data](https://www.searchenginejournal.com/free-data-sources/302601/)

* [100+ of the Best Free Data Sources For Your Next Project](https://www.columnfivemedia.com/100-best-free-data-sources-infographic/)

## Recommended Viewing and Reading 

TBD

## Set Up

1. **Create a Twitter account and Google account** if you don't already have them. You'll need these accounts to search for tweets using code and to use the Google Maps API.


# Text

## Loading Text 

Sketch: **`text`**

This is a minimal sketch showing how to load text from a file. The output is printed to the console and to a textarea (there is no graphical output).

It uses the p5.js `loadStrings()` function to load the lines of the specified file src as an array of strings of text. The second argument is a callback function to execute after the text is loaded:

```js
  let lines = loadStrings(src, function() {
    print(`  loaded ${lines.length} lines`);  
    // ...
  });
```

To get all the text in a file as a single string, we join the strings returned from `loadStrings()`:
```
text = lines.join('\n');
```

### Loading Text from a Another Website

`loadStrings()` can load content from anywhere by passing a url instead of a filepath. 

Try changing the code to this:
```js
let src = "https://www.gutenberg.org/cache/epub/158/pg158.txt";
```

> **WARNING!** This will cause a **Blocked by CORS Policy*** error until you explicitly allow this kind of access. 

### Cross-Origin Resource Sharing (CORS)

When you call loadStrings, its using a low-level JavaScript method that fetches data off of a remote server. This is fine if the remote data is on the same server (like `LocalHost` for your local VS Code server), but due to potential security threats, all modern browsers prevent code executing in a browser window from accessing data on other servers. [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) is the name of the security policy enforced. 

In our sketch, we just want to load a text file from the Project Gutenberg site. There's really no security threat here. To allow access, the easiest way is to remove the CORS policy from your browser. The easiest way is with a plug-in like [Allow CORS](https://chrome.google.com/webstore/detail/allow-cors-access-control/lhobafahddgcelffkeicbaginigeejlf?hl=en) for Chrome or [CORS Everywhere](https://addons.mozilla.org/en-CA/firefox/addon/cors-everywhere/) for Firefox. On Safari, you can disable CORS in the develop menu (Preferences > Advanced, select “Disable Cross-Origin Restrictions”).

These settings only make your browser allow CORS, if you share a sketch that loads data from remote servers with others they would have the same CORS policy error. A more universal approach is to use a proxy server like [cors-anywhere](https://github.com/Rob--W/cors-anywhere#readme). 

> For this course, the browser extension approach should be enough for installation artworks, etc., unless you want to post your sketch on a public webserver.

Here's a [short Medium article](https://medium.com/@dtkatz/3-ways-to-fix-the-cors-error-and-how-access-control-allow-origin-works-d97d55946d9) that explains what the CORS policy is (a bit technical) and some solutions. Here's [another short Medium article](https://medium.com/swlh/avoiding-cors-errors-on-localhost-in-2020-5a656ed8cefa) that has a few more solutions and is a bit lighter technically. 

## Processing Text 

Sketch: **`gutenberg`** 

Like the previous sketch, this sketch loads text from Project Gutenberg, a collection of out-of-copyright digitized texts. The sketch processes the book [*Pride and Prejudice* by Jane Austen](https://www.gutenberg.org/files/1342/1342-0.txt) into individual words, and plays the words in sequence as an animation.

*Cleaning*: To prepare the words to display, the sketch first removes the frontmatter (including language, release date, encoding, etc.). We iterate through each line returned from `loadStrings`, checking if it's the last line of the frontmatter by seeing if it contains text that we know is in the last line of the frontmatter (in the variable `start`). For example, in the case of *Pride and Prejudice*, the last line of text in the frontmatter is the last entry in the book's table of contents ("Chapter 61"), so we set

```js
let start = "Chapter 61";
```

The sketch then adds the remainder of the file (the book contents without the frontmatter) to a string.

### String Tokenization 

To get the individual words from the text to display, we use the p5.js `splitTokens(string, delimiter)`, which splits up a string at one or more occurrences of any character in `delimiter`. We pass in the book text as the `string` and `" "` (a space character) as the `delimiter`. This process is called *tokenization*.

Processing has other functions that you may find useful for tokenization and other processing. The `split()` function works like `splitTokens()`, but splits on a specific substring rather than a set of characters. For example,

```js
splitTokens("a, b,c d", ", ")
```
produces the array
```js
["a", "b", "c", "d"]
```

whereas

```js
split("a, b,c d", ", ")
```
produce the array
```js
["a", "b,c d"]
```

We also use the JavaScript string method `.includes(substring)`, that returns whether or not the string includes the given substring.

### Animation

To show the words at regular intervals, the sketch uses a parameter called `update` (controlled by the mouse's `x` position) as follows:

```js
if (frameCount % update == 0) {
  index++;
}
```

`frameCount` is the number of frames that have been shown since the sketch was first started (there are 60 frames per second, unless set differently using `frameRate()`). "`%`" is the modulo operator. When `frameCount % update` is equal to zero, this means that `frameCount` is divisible by `update` without a remainder. In other words, if `update` is set to `60`, this means that `index` will increase each second, whereas if `update` is set to `1`, this means that `index` will increase 60 times per second.

To make the fading effect, background is called with an alpha transparency `p.alpha`:

```js
// semi transparent background to fade words
background(0, p.alpha * 255);
```

This makes previous white words dimmer and dimmer each frame until the next word is shown.

### Extra

To give the text a "floating" effect, try uncommenting the lines:

```js
let floatRange = 100;
y += -floatRange/2 + floatRange * noise(frameCount/500.0);
```

This causes the y-position of the word to float up and down, controlled by the p5.js `noise()` generation function.

## Try and Experiment

To better understand how to load and process data, let's visualize a piece of computer code as abstract fields of brackets. Try following these steps:

1. Add an extension or configure your browser to allow CORS access (see above).
2. Copy the `text` sketch as a starting place.  
3. In your copy, load some public source code from GitHub. For example, [`main.js`](https://github.com/processing/p5.js/blob/main/src/core/main.js) is the main module for p5.js.
4. Create a loop to iterate through each character in the string of code (stored in the String `all` if you use the minimal text demo as starter code). 
    - `all.length` will give the total number of characters
    - `all.charAt(i)` will return the character at a position in the string
5. In your loop, add a condition to only render the character using the `text()` function when the character is a bracket (square, round, curly).
6. You'll have to keep track of the x and y position, similar to the temperature demo below.
7. Tweak the spacing of characters, their fill colour (with transparency), and the size of you canvas (try it tall and thin like a print).
8. You can make this "paint" the characters over time by tracking the current character position in a global variable and incrementing it each frame (which might be pretty slow) or write a loop in draw to look at 100 characters or so each frame.


# Tabular Data

Tabular data is also a text file, but it's structured as rows and columns of data. The type of data is usually consistent, for example a column of data is numeric or has a certain format like a postal code.  

## Loading CSV Data

Sketch: **`csv`** 

This is a minimal sketch showing how to load a csv into a p5.js `Table`, display some meta information, and iterate through the data. The output is printed to the Processing console (there is no graphical output).

p5.js has built-in functions and classes enabling loading of csv ("comma-separated values") files. These are plain text files in which each line of text represents a row of a table, and columns of the table are delimited using commas (",") in each line of text in the file. The csv file included with this sketch is a table of Canadian postal codes and their corresponding place names, provinces, and coordinates.

To load a csv file, we use the `loadTable()` function. Just like  `loadStrings()`, this can take in either a local filename or a URL pointing to a remote file. `loadTable()` returns a `p5.Table` object, a class built into p5.

The [`Table` class](https://p5js.org/reference/#/p5.Table) has various methods to read and manipulate the table. For example, `.getRowCount()` and `.getColumnCount()` can be used to figure out the size of the table. Table columns can be indexed either using their number (int) or their title (string). To get all the column titles, use the `.columns` property.

In this sketch, we iterate through the rows of the table. In each iteration, we obtain the row using `table.getRow(i)` where `i` is the row number. Each table row is represented using the `TableRow` class. We use the `TableRow.getString()` method to get the place name as a string for each row. `TableRow` has `.getNum()` to extract a numerical types from table cells.

## Processing a CSV

Sketch: **`temperature`** 

This sketch loads historical weather readings taken every 15 min from the [UWaterloo Weather Station](http://weather.uwaterloo.ca/) and displays the temperatures over the year of 2016 in a simple visualization.

Like the previous sketch, this sketch uses `loadTable()` to load a csv file, but this time, the file is loaded from a URL rather than a local file.

The visualization works by representing the temperature at a given time as the colour of a pixel. The width of the canvas represents the time span of one day, and each different y value along the height of the canvas represents a different day during the year. The hotter or colder the temperature, the brighter the pixel colour. Positive temperatures are visualized in red, whereas negative temperatures are visualized in blue.

We use the `HSB` colour model to adjust the brightness and hue of the colours to visualize with. To put your sketch into `HSB` mode, we use:
```js
colorMode(HSB, 360, 100, 100, 100);
```
which gives us a hue range of 0 to 360, and saturation, brightness, and opacity range of 0 to 100.

## Try and Experiment

Let's start from the `csv` sketch to try and make a visualization similar to the `temperature` sketch. Try following these steps:

1. Extract the longitude and latitude of each postal code using the `TableRow.getNum()` method (like in the temperature demo).
   
2. Plot the latitude and longitude as a point. You need to `map` longitude values to the x-coordinate and latitude values to y-coordinate. 
   * Longitudes range from -139.4351 (West Coast) to -52.6961 (East Coast)
   * Latitudes range from 70.4643 (North) to 42.0377 (Southern border)  
   * (I left out postal code H0H, see the csv file!)
   
3. To make it more dynamic, plot one point each frame in `draw()`. This means you need to keep track of a row index for the table, and increase it each frame.

To experiment further:

* Experiment with different size points (using `strokeWeight()`) and different colours and transparency (using `stroke()`).
  
* You can also try connecting the postal code points by lines.
   <!-- and try different sort orders on the table to see the effect (see the `Table.sort()` and `Table.sortReverse()` methods). -->

# RSS Feeds in XML

RSS stands for [Really Simple Syndication](https://en.wikipedia.org/wiki/RSS), an XML-based feed format.

> Warning: Avoid requesting RSS feeds from websites many times in quick succession (like every frame in your sketch), because you could be blocked from the webserver.

## Loading RSS and Parsing XML

Sketch: **`rss`**

This sketch loads an RSS feed of [curling news](http://www.cbc.ca/cmlink/rss-sports-curling) and shows how to do some XML processing by printing the title of each news story. The output is printed to the Processing console (there is no graphical output).

RSS data is just a specific format of feed data stored as XML, and is usually hosted on a webserver. To load in the XML feed, we use the `loadXML()` function. This function can takes either a local filename or a URL pointing to a remote file, just like `loadStrings()` and `loadTable()`. `loadXML()` returns an instance of the p5.js `XML` class.

To figure out where the data is within the XML RSS feed, you can inspect it using a web browser, or download it and use a text editor. Try opening the [feed XML in the sketch](http://www.cbc.ca/cmlink/rss-sports-curling) to see what it looks like. The `<![CDATA[ ... ]]>` tags you see around text are special tags indicating that the contained text is *character data*, and should not be interpreted as XML itself.

In the case of this curling news, there is one `channel` tag (called an xml "element") that contains several `item` tags. Each `item` a single news story with a `title` tag for the title as well as other elements for things the publication date, story description, etc. 

To access constent in a specific xml element, we use `.getChild("channel")` to get the channel tag, and then `.getChildren("item")` to get an array of `XML` objects representing each of the item elements. Iterating through each item element, we get the title text with `.getChild("title").getContent()`.

## Weather XML

Sketch: **`forecast`**

This sketch loads a [weather feed](https://weather.gc.ca/rss/city/on-82_e.xml) from the Government of Canada, and displays current weather conditions for Canadian cities. Press a key to get the weather for a new random city (unless it guess the wrong city code).

As with the `rss` sketch, we have to understand the structure of the feed and can do this by opening the XML in a web browser. 
* Near the top is a `title` tag with the name of the weather location. 
* Farther down are a series of `entry` tags, each one has a `title` tag that describes what is in the entry. For example "Current Conditions" or a day and time period for a forecast.

The Government of Canada's weather website indexes each region by province and an id number. For example, Kitchener-Waterloo is Ontario 83, Toronto is Ontario 143, and Vancouver is British Columbia 74. Because the mapping of these numbers is unclear, this sketch tries a random number from 1 to 99. 

### Other Weather Feeds and Resources 

* [ec-weather](https://github.com/jschnurr/ec-weather) is a library to transform the Environment Canada weather forecast raw feed raw into clean, well formatted JSON.

* [Another weather feed](https://eccc-msc.github.io/open-data/msc-data/citypage-weather/readme_citypageweather-datamart_en/)


<!-- #### Sketch: **`transit`**
- routes
- bus locations

* You can [include Java jar files into your sketch](https://forum.processing.org/two/discussion/10188/import-an-external-jar-into-my-sketch)


http://www.grt.ca/en/about-grt/open-data.aspx -->


## Try and Experiment

Let's extract a block of html with various readings from a real ocean buoy. Try following these steps:

1. Start with this RSS feed: [http://www.ndbc.noaa.gov/data/latest_obs/51202.rss]()
2. Open it in the browser and look at the XML (note this one has a style sheet, so you may need to "view source" to see raw XML)
3. Locate the `<description>` block.
4. Create a sketch to open the feed, extract the `<description>` as a string, and print out the value.

To experiment further:

* Use [`match` and a regular expression](https://p5js.org/reference/#/p5/match) to extract a specific value, like "Significant Wave Height"
* Translate the buoy information into a visualization (what could you do?)
* Query many buoys at regular intervals to create a combined visualization (see a list at [National Data Buoy Center](http://www.ndbc.noaa.gov/)).


# Querystring Data APIs 

## Loading Data

Sketch: **`streetview1`**

This sketch shows how to grab Google streetview images using the Google Streetview Application Programming Interface (API). An API is a way for organizations to share data and functionality with programmers without the programmers having access or knowledge of the internal workings of the server application. There isn't any standard way to design an API, often each one is slightly different. In almost all cases, an API will require the developer to have a key so the organization can identify who's accessing their server and in some cases, also charge developers access.

Google Streetview uses a *querystring API*, meaning that it works by adding parameters to a special API URL performs actions using the API. Think of it like a function call using a special URL.

To get an image from Streetview, the URL *endpoint* is: https://maps.googleapis.com/maps/api/streetview. The parameters `size` (how big the image should be), `location` (a string representing a location, e.g., "48.8742,2.2948", "Kitchener,ON"), `fov`, `heading`, and `pitch` (these three represent the camera field-of-view and direction at the given `location`), and `key` (the API key you generated).

The start of the parameter list is indicated with "`?`" in the URL. Each parameter is included in the format `parameter=value`; for example, `size=500x500`. Multiple parameters are separated with "`&`". The sketch concatenates strings together to form a complete querystring:

```js
let url = "https://maps.googleapis.com/maps/api/streetview" + 
  "?size=" + w + "x" + h + 
  "&location=" + location + 
  "&fov=" + fov + "&heading=" + head + "&pitch=" + pitch + 
  "&key=" + API_KEY;
```

### API Key Setup

You need a [Google Streetview API Key](https://developers.google.com/maps/documentation/streetview/get-api-key) to run this code. It's a string of 38 characters that looks something like this:

```
uX83P2JVh0z49wJroBu9yAVdejmhFUoFAIzaS7F
```

To get one, you need to have a Google account and you do need to provide billing information to Google (i.e. a credit card). You may already have this setup if you buy apps on the Android Play Store.

> The cost to use this API is very low, about 0.8 cents per image with a credit of US$200 each month. So you'd have to retrieve about 25,000 streetview images in a month before you start paying. That's like retrieving one streetview image every second for more than two weeks, or creating a sketch that retrieves a streetview images every frame (at 60 FPS) and running your sketch for 7 hours. 

We also recommend that, for the course, you enable the "Allow Unsigned Usage" option of your Streetview API key, to avoid having to cryptographically sign every request to the API. To do this, navigate to:
https://console.cloud.google.com/google/maps-apis/credentials
Select "Street View Static API" from the drop-down, and then select "ALLOW UNSIGNED USAGE".

### API Key Security

You don't want to include your API key in your repo. One way to keep it out is to create a `_private/` folder to your sketch folder, and add an ignore `_private/` rule to `.gitignore`, then store your auth there in a json file that you load when your sketch runs. There's a sample `auth.json` in the directory and the sketch is set up to load from a file like that in a `_private/` subfolder.

However, it's impossible to hide an API key when it's used directly by a JavaScript program running in a webpage. Even if you keep you API key in a `_private` folder on a public website, people can get your key. The only secure way to use API keys in a public website is to handle all API accesses on your own server. This way your API key never leaves your server, and it just forwards the results of the API access to your webpage application. 

> For this course, we are most likely creating artworks that are not hosted on a public server, so it should be fine to use the non-server approach used in this demo sketch.

## Processing

Sketch: **`streetview2`**

This sketch grabs images of random postal code locations.

> Note: You need a Google Streetview API Key to run this code, see above.

This sketch uses a csv table of Canadian postal codes and latitude-longitude coordinates as the source of locations. It picks a random postal code, and passes the corresponding coordinates to the Streetview API. This is an example of how an artwork might combine multiple data sources in one piece.

Note in some cases, there is no streeview image, so you'll see a defaut grey image not found image. 

> There is some unfinished code for a `isStreetViewImage()` function to check if there's a streetview image at the specified lat and long location.
It uses the `metadata` Streetview "endpoint" which returns a JSON object describing the image. For instance, there's a `status` that will be `"OK"` if  the location has a corresponding image. 

## Try and Experiment

Set up your own Google API key, and run the streetview1 and streetview2 code. 

## Reference

[Google Street View Image API](https://developers.google.com/maps/documentation/streetview/intro)

# OAuth APIs

## Twitter API to Access Tweets

Sketch: **`twitter`**

This sketch grabs a set of 100 tweets matching a given keyword ("#poem" by default).
It uses [**CodeBird JS**](https://github.com/jublo/codebird-js) and requires Twitter API OAuth keys and tokens. 

### OAuth

See the `readme.md` file in the twitter code folder for instructions on setting up OAuth on Twitter. You will need 4 strings of characters for OAuth, which you'll put in a `auth.js` file in the `_private/` folder. Here's an example:

```json
{
    "CONSUMER_KEY": "jJKwYVKkqnSkbr63NpK7Vzvkx",
    "CONSUMER_SECRET": "lTMfwMs7rDxz8vPcxBD7Gy5lDO8GXnlIzPw2d8xVhqa1L4xOTw",
    "TOKEN": "364475473-kMBumzdzoxKZcduTwFGizG0iyMldRx1CQtcRXm2w",
    "TOKEN_SECRET": "KBjBbqUZ0of2SQZDFEqSFof7kQPpENigIh7d3BMUQyCjN"
}
```

### Using Codebird to fetch tweets

Create a Codebird object a global variable:

```js
var cb = new Codebird();
```

Set the OAuth keys:

```js
// set OAuth keys
cb.setConsumerKey(CONSUMER_KEY, CONSUMER_SECRET);
cb.setToken(TOKEN, TOKEN_SECRET);
```

Create a JSON object with to describe the parameters for a Twitter API function call:

```js
let parameters = {
    q: keyword,
    result_type: 'recent',
    count: 20
  };
```

Call the Twitter API function with the parameters and provide a callback function for the reply:

```
cb.__call(
    'search_tweets',
    parameters,
    function(reply) { ... });
```

The reply from a 'search_tweets' has an array of `statuses`. Each status has several fields like the tweet `text`, language of the tweet, an array of tags that were used, etc.

There is much more to [Twitter Developer APIs](https://developer.twitter.com/en.html) and search Tweet functionality in [CodeBird JS](https://github.com/jublo/codebird-js) library. 


# Sketchbook Exercise 

Extend one of the exercises or demos from this workshop to create a small computational artwork that uses data as input. Capture and include an image of your artwork (or series of images or even a short video), and provide a brief (approx. 250 word) description of what data you used and how you use the data within your artwork.





