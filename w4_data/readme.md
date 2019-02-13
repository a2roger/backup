# Workshop 4: Data

Learn about a variety of ways to access data, process it, and some ideas what to do with it.

## Goals

* Use `loadStrings` to read in lines of text and perform basic text processing.
* Use `Table` to load and index data from a CSV file.
* Use `XML` to load and search for content in a RSS feed.
* Create querystring URLs to access data 
* Use `JSONObject` to process responses from data sources
* Learn about OAuth and the Twitter API


<!-- #### Required Reading

**  -->

# Pre-workshop Set Up

Try to complete the following __before__ the Workshop class.

#### 1. Install required libraries

* **Simple Tweet** for reading and posting to Twitter

Do this just like you did for the Video libraries in Workshop 0.`Tools/Add Tool...`, click on "Libraries" tab, search for library name and click "Install". 

#### 2. Verify the libraries work

To test the Simple Tweet library, try running the `SearchTwitter` sketch from the the `Contributed Folders` tree folder in `File/Examples...`. Since you haven't setup OAuth yet, the sketch will crash with a message beginning with an "ArithmeticException: /by zero" error and a message in the console starting with "400:The request was invalid." As long as you see the same error and message for the crash, everything should be installed correctly. We'll setup OAuth for Twitter in class.

> Post to Slack if you have trouble running the library demos. Please provide details so we can diagnose (e.g. operating system, error messages, steps to reproduce the error)  

#### 3. Get the latest "Workshop" code from Gitlab

Hopefully you have git installed and working, just type `git pull` in the terminal. 

#### 4. Create a Twitter and Google account if you don't already have them.

You'll need these accounts to search for tweets using code and to use the Google Maps API.


# In-Class Workshop

During the workshop, we'll review the different Processing code examples in this directory. Each sketch serves to demonstrate techniques to get historical, current, or real-time data that could be used as input. 

## Text

#### Sketch: **`text`** 

Minimal sketch to load text. 

* `loadStrings` to load text from a file or URL
* `String.join` to put all text back into one string.

#### Sketch: **`gutenberg`** 

Loads text from Project Gutenberg, processes it into individual words, and plays the words in sequence as an animation. 

* processing data: cleaning, tokenizing
* `split`, `startsWith`, ...
* using `frameCount % update == 0` to do something at regular intervals

Extra
* transparency and partial background for animation effects

#### Try and Experiment

Visualize code as abstract fields of brackets.

* Load some public source code from GitHub. For example, [`core.java`](https://raw.githubusercontent.com/processing/processing/master/core/src/processing/core/PApplet.java) from the Processing language.
* Create a loop to iterate through each character in the string of code (stored in the String `all` if you use the minimal text demo as starter code). 
   - `all.length()` will give the total number of characters
   - `all.charAt(i)` will return the character at a position in the string
* In your loop, add a condition to only render the character using the `text()` function when the character is a bracket (square, round, curly). 
* You'll have to keep track of the x and y position, similar to the temperature demo below.
* Tweak the spacing of characters, their fill colour (with transparency), and the size of you canvas (try it tall and thin like a print).
* You can make this "paint" the characters over time by tracking the current character position in a global variable and incrementing it each frame (which might be pretty slow) or write a loop in draw to look at 100 characters or so each frame

#### References

[Data Chapter from Shiffman's book](https://processing.org/tutorials/data/)

## Tabular Data

#### Sketch: **`csv`** 

Minimal sketch to load a csv into a `Table`, display some meta information, and iterate through the data.

* `loadTable` to load csv data from a file 
* `Table` class for accessing csv data ([reference](https://processing.org/reference/Table.html), [javadoc](http://processing.github.io/processing-javadocs/core/processing/data/Table.html))
* column titles and types
* iterating through rows
* getting data by column in a row

#### Try and Experiment

Plot the latitude and longitude of each postal code as a point.
* You need to `map` longitude values to the x-coordinate and latitude values to y-coordinate. 
  - Longitudes range from -139.4351 (West Coast) to -52.6961 (East Coast)
  - Latitudes range from 70.4643 (North) to 42.0377 (Southern border)  
  - (I left out postal code HOH, see the file!)
* Access the longitude and latitude using `getFloat` method of the `TableRow`. See the code demos above.
* To make it more dynamic, plot one point each frame in `draw`. This means you need to keep track of a row index for the table, and increase it each frame.

Experiment further:

* Experiment with different size points (using `strokeWeight`) and different colours and transparency (using `stroke`)
* You also try connecting the postal code points by lines, and try different sort orders on the table to see the effect (see `sort` and `sortReverse` methods of table)

#### Sketch: **`temperature`** 

Loads historical weather readings taken every 15 min from the [UWaterloo Weather station](http://weather.uwaterloo.ca/) and displays temperatures in a simple visualization.

* `loadTable` with a URL
* transforming data to a visualization
* `colorMode` to specify colours in HSB space

## RSS Feeds in XML

RSS means [Really Simple Syndication](https://en.wikipedia.org/wiki/RSS)

> Warning: Avoid requesting RSS feeds many times in quick succession (like every frame in your sketch), you could be blocked from the webserver.

#### Sketch: **`rss`**

Loads an RSS feed of [curling news](http://www.cbc.ca/cmlink/rss-sports-curling) and does some XML processing. Open the feed in your browser to see the XML.

* Using `loadXML` to get RSS data (RSS data is just XML from a web server)
* Strategy to figure out where data is in the XML RSS feed by loading it in a web browser
* Using the `XML` class methods to extract the information you want
    - `getChild`, `getChildren`, `getContent`, ...
* Iterating through XML objects

#### Sketch: **`forecast`**

Loads a [weather feed](https://weather.gc.ca/rss/city/on-82_e.xml) and displays current weather conditions for Canadian cities. Press a key to get the weather for a new random city.

* Strategy to figure out where data is in the XML RSS feed
* `try` and `catch` to handle exceptions, like bad URL


<!-- #### Sketch: **`transit`**
- routes
- bus locations

* You can [include Java jar files into your sketch](https://forum.processing.org/two/discussion/10188/import-an-external-jar-into-my-sketch)


http://www.grt.ca/en/about-grt/open-data.aspx -->


#### Try and Experiment

Extract a block of html with various readings from a real ocean buoy;

* Start with this RSS feed: [http://www.ndbc.noaa.gov/data/latest_obs/51202.rss]()
* Open it in the browser and look at the XML (note this one has a style sheet, so you may need to "view source" to see raw XML)
* Locate the `<description>` block.
* Create a sketch to open the feed, extract the `<description>` as a string, and print out the value.

Extend

* Use [`match` and a regular expression](https://processing.org/reference/match_.html) to extract a specific value, like "Significant Wave Height"
* Translate the buoy information into visualization (what could you do?)
* Query many buoys at regular intervals to create a combined visualization (see a list at [National Data Buoy Center](http://www.ndbc.noaa.gov/)).


#### Reference

Useful, but somewhat out-of-date tutorial on RSS in Processing: 
[Till Nagel, Creative Coding, Processing RSS feeds](http://btk.tillnagel.com/tutorials/rss-feeds-processing.html)


### Querystring APIs and JSON Processing

#### Sketch: **`streetview1`**

Grabs Google streetview images using the Google Streetview API.

> Note: You need a Google Streetview API Key to run this code.

* Querystring API
* Creating and using API key


#### Sketch: **`streetview2`**

Grabs images of random postal code locations.

> Note: You need a Google Streetview API Key to run this code.

* JSON response
* Combining multiple data sources

#### Try and Experiment

TBD


#### Reference

[Google Street View Image API](https://developers.google.com/maps/documentation/streetview/intro)

### Official APIs, OAuth, and API Libraries

#### Sketch: **`twitter`**

Grabs a set of 100 tweets matching given keyword.

* [**Simple Tweet** Processing library](https://github.com/gohai/processing-simpletweet)
* [**twitter4j** Java library](http://twitter4j.org/en/)
* Setting up OAuth on Twitter (see instructions in code) 
* Searching for tweets and displaying them

There is much, much more to [Twitter Developer APIs](https://developer.twitter.com/en.html) and Search Tweet functionality in the twitter4j Java library. Note that not all of the Twitter API calls are wrapped in the Processing Library, but you can access them directly with "native" Java calls.

[Useful blog entry explaining OAuth, Simple Tweet, and twitter4j](http://blog.blprnt.com/blog/blprnt/updated-quick-tutorial-processing-twitter)


#### Try and Experiment

TBD


# Exercise

Extend one of the exercies or demos to create a small computational artwork that uses data as input.


# References and Resources

[Big Data: 33 Brilliant And Free Data Sources For 2016 (Forbes)](
https://www.forbes.com/sites/bernardmarr/2016/02/12/big-data-35-brilliant-and-free-data-sources-for-2016/#fe34cc3b54db)

[50 Amazing Free Data Sources You Should Know (inforgram)](https://infogram.com/blog/free-data-sources/)

 




