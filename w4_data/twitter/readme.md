 # Setup Twitter OAuth

 You need to have OAuth keys from Twitter to access Twitter data from a program. The steps below assume you already have a Twitter user account.

 ## Create an OAuth file

 Create a json file to store your OAuth keys. The twitter demo program will use these keys to connect to Twitter. Name the file `auth_twitter.json` and paste this text:

```
{
  "APIKey" : "", 
  "APISecretKey" : "",
  "AccessToken" : "",
  "AccessTokenSecret" : ""
}
```

> NOTE: The twitter demo program expects this auth file to be in the parent directory to the entire git repo. [Read why](https://nakedsecurity.sophos.com/2019/03/25/thousands-of-coders-are-leaving-their-crown-jewels-exposed-on-github/) it's **very important to not save API keys to git**.

 
 ## Apply for a Twitter Develeper Account
 
1. Apply for an Individual Twitter Developer account at 
    https://developer.twitter.com/en/apply-for-access
    - click "Apply"
    - choose "Student" under "Academic"
    - verify your Twitter account and provide country
    
3. Fill out the "How will you use the Twitter API form ..."
     
    **For "In your words":**

        Exploring methods to create data-driven art in a programming workshop in course CS/FINE 383 held at the University of Waterloo, Canada. Programs will be written in Processing with the goal to create simple artworks based on text captured from twitter. Artworks will be shown in class or possibly in a final gallery show.        
        
    **For "The specifics":**
    
    No to all except ... 
        
    Yes to "Are you planning to analyze Twitter data?", describe as:

        Tweets or twitter users may be analyzed for types of word use,  statistics like length or time, statistics about related images, etc. The goal is to perform analysis for the purpose of generating data-driven artworks only.  The results might be shown to the class (less than 20 people) or exhibited within the University for a short period, or in a final class gallery show at the end of the semester.

    Yes to "Do you plan to display tweets or aggregate data ...", describe as: 

        Tweets or data about twitter content will be displayed in custom programs running on a personal computer. The results might be shown to the class (less than 20 people) or exhibited within the University for a short period, or in a final class gallery show at the end of the semester.
        
4. Submit and finish application process by verifying your email.
      
5. After verifying, your account may already be approved.

 ## Create an Application and Setup OAuth

1. Create a new application
   
    **For "Application description":

        Data Artwork

     **For "Tell us how this app will be used":

         A program to create artwork from Twitter data. This is part of a worksop and possible and assignment for CS/FINE 383 held at the University of Waterloo, Canada. 

    Click submit

2. Go to "Keys and tokens" tab.

3. Copy the "API key" and "API secret key" into the corresponding valuses in the `auth_twitter.json' file.

4. Click the button to generate the access tokens for your account and copy and paste those values into the `auth_twitter.json' file as well.

When done, your `auth_twitter.json` file should look something like this:

```
{
  "APIKey" : "Rg7iA7sbpjAnBs0aFx7XC9n7r", 
  "APISecretKey" : "bCl5hBxx2xrAgzZ2iWRFFT2KziF8VXYggbjePsQF78szfPaw",
  "AccessToken" : "782666629-H6CW01iD99Ur5tW4ff7EbPl6cGlid8675vaypckt",
  "AccessTokenSecret" : "bZNMuEhDDfq22eddFFFtQcVjN8o61AhhGf7u1FhW5XLH4ip"
}
```


