---
title: "Assignment 5: Working with APIs"
author: "Kenneth Benoit"
date: "26/10/2017"
output:
  md_document:
    variant: markdown_github
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```


## Instructions

This file is an RMarkdown file, which is slightly different from a Jupyter notebook.  You will need to open it within [RStudio](https://www.rstudio.com), and compile it to a Markdown file using the **knitr** package.  From RStudio, this is the "Knit" button that appears in the top edge of your Source pane.  When you knit it, will will execute the code in your code blocks, and render the output as formatted Markdown.  

There are plenty of instructions about how to use RMarkdown, such as [these](http://rmarkdown.rstudio.com/authoring_rcodechunks.html).  If you define a code block using Python, then any code within that block will be executed in Python.  It works with [other languages](http://rmarkdown.rstudio.com/authoring_knitr_engines.html) too.  

#### Deadline: Wednesday 5pm, 8 November

## Part A: Working with APIs (20 points)

1.  Try using `curl` to get a website from `http://www.example.com`.  This one is provided for you, as an example.  On Windows, you might need to change the language engine to something other than bash.  (See http://rmarkdown.rstudio.com/authoring_knitr_engines.html#bash)

<!-- ```{bash} -->
<!-- curl http://www.example.com -->
<!-- ``` -->

2.  Get the information from the [GitHub API](https://developer.github.com/v3/repos/#get) about the [`lse-st445/lectures`](https://github.com/lse-st445/lectures) repository.  You will need to use `curl` for this, but you are welcome to use the [**RCurl**](https://cran.r-project.org/web/packages/RCurl/index.html) package for R, or the [PycURL](http://pycurl.io/docs/latest/) module for Python to do this.  The examples below give you the starter code you need for the R solution.

    Hint: Part of the URL will be `repos/lse-st445`.
    
```{r, warning=FALSE, message=FALSE}

library('curl')
library('jsonlite')
library('RJSONIO')

setAPI <- "https://api.github.com/repos/lse-st445/lectures"  
dataList <- fromJSON(setAPI)  
dataList

```
  
    
## Part B: Working with Twitter Data (50 points)

1.  Use the **twitteR** package for R to look up the last 2,000 Tweets from [Donald Trump's Twitter feed](https://twitter.com/realDonaldTrump).  Save the output to an object called `trump_tweets`, as a data.frame.

    (Note that in the code block, you will need to change the `eval = FALSE` to `eval = TRUE`.)

```{r, warning=FALSE, message=FALSE}

    library("twitteR")
    require("twitteR")
    library("devtools")
    library("stringi")
    library("RJSONIO")
    library("RCurl")
    library('httr')
    library("XML")
    library('ROAuth')
    
    # replace with your credentials
    # get these from https://apps.twitter.com/
    
    api_key <- "hUVOQGsCFPYUCpqTJjDdKR2z8"
    api_secret <- "i3OTR91VmgvJRUJ1BjHroG6luA0MAWfalazG7jK0fW7VqEfziw"
    access_token <- "925148387183353857-gqXqtwb9MfzsQA7wyxLuGf1VTzxm2On"
    access_token_secret <- "iabbgPb93khGo3lUjdWKmxzMQqj3JkL6HmOiRQbrjRuZB"
    
    # authorize the Twitter access
    
    setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)
    
     # use userTimeline()
    
    tw <- userTimeline("realDonaldTrump", n = 2000, includeRts = TRUE)
    
    # use the command from lecture notes to convert result into a data.frame
    
    trump_tweets <- twListToDF(tw)

```

2.  Display the output of the first 20 Tweets.  What sort of returned information is in the result?

```{r, warning=FALSE, message=FALSE}
  library('stringi')
  trump_tweets[["text"]] <- stri_enc_toascii(trump_tweets[["text"]]) 
  trump_tweets[1:20, ]
```

3.  How could we convert the information about the device into a simpler variable, containing just the device?
```{r}
  
  devices <- trump_tweets$statusSource
  devices <- htmlParse(devices, asText=TRUE)
  devices <- xpathSApply(devices, "//a", xmlValue)

```


4.  Use the **quanteda** package to save this to a corpus object, look up the result using the Lexicoder Sentiment dictionary (see `?data_dictionary_LSD2015), and plot the positive versus negative balance using a barplot.

    ```{r, warning=FALSE, message=FALSE}
library(ggplot2)

suppressPackageStartupMessages(library("quanteda"))
trump_corpus <- corpus(trump_tweets)
docvars(trump_corpus, "device") <- devices
trump_sentiment <- dfm(trump_corpus, groups = "device", dictionary = data_dictionary_LSD2015[1:2])

# plot a barplot of positive versus negative

df <- data.frame(device = rep(rownames(trump_sentiment),2), 
                 Content = rep(featnames(trump_sentiment),each=nrow(trump_sentiment)),
                 Frequency = c(as.numeric(trump_sentiment[,'negative']),
                               as.numeric(trump_sentiment[,'positive'])), 
                 row.names = NULL, stringsAsFactors = FALSE)

p <- ggplot(data=df, aes(x=device, y=Frequency, fill=Content)) +
  geom_bar(stat="identity", color="black", position=position_dodge())+
  theme_minimal() + theme(axis.text.x = element_text(angle = 90, hjust = 1))
p
    ```



## Part C: Working with Facebook Data (30 points)

1.  Access the last 20 Facebook posts from [Donald Trump's public page](https://www.facebook.com/DonaldTrump/).  You can find starter code [here](https://github.com/kbenoit/ITAUR/blob/master/6_advanced/social_media_example.R), and you can use this to follow the examples.

    ```{r, warning=FALSE, message=FALSE}
    
    library("Rfacebook")
    library("devtools")
    
    # Access token: https://developers.facebook.com/tools/explorer/
    
    token <- "EAACEdEose0cBAMVnZAt0VN4aDhOdZC7TpjdBZAoGUOZAmLFAftgBYULVk0F4vuYACQAZAZAyitBASlkVMlXM6j7LU5MdRo0b50fzpX5PgKZAZCtQPfvHg4wo3jKWhPCNipvoeYhZBSdQegBG0zRCWVf4S2a2ka5IWPwfwtyDHM8UuIzoHle3Falbg2lQ1PtsUzhsZD"
    
    me <- getUsers("me", token, private_info = TRUE)
    me$name
    
    require("Rfacebook")
    
    # use getPage() here
    # I access and display them. 
    
    fb_post <- getPage(page="DonaldTrump", token=token, n = 20,feed = TRUE)
    fb_post_1 <-fb_post$message[1:20]
    fb_post_1
    
    ```

2.  Display the first 5 posts.

```{r}
 
fb_post_2 <-fb_post $message[ 1:5 ]
fb_post_2
```

3.  (Extra credit)  Do some analysis, plot, or any other analytics with the data from 1 and 2.  You can follow the `social_media_example.R` linked above for inspiration, or even reproduce that.

```{r, warning=FALSE, message=FALSE}
  
  
  # I would like to compare the number of likes_count,comments and shares of these 20 posts.

  library('ggplot2')

  FB_df <- data.frame(
  id = c(1:nrow(fb_post)),
  likes_count = fb_post$likes_count,
  comments_count = fb_post$comments_count,
  shares_count = fb_post$shares_count,
  stringsAsFactors = F
  )

setRate <- round(max(FB_df$likes_count)/max(FB_df$comments_count))
pl <- ggplot(FB_df) + 
      geom_bar(aes(x=id, y=likes_count),fill="tan1",stat="identity") +
      geom_line(aes(x=id, y=comments_count*setRate,colour="comments"),stat="identity") + 
      geom_line(aes(x=id, y=shares_count*setRate,colour="shares"),stat="identity") + 
      scale_y_continuous(sec.axis = sec_axis(~./setRate)) + 
      scale_colour_manual("variable",values=c("blue","red"))
pl  


# I would like to create a wordcloud of these 20 posts.

library("quanteda")

mydfm <- dfm(fb_post$message, remove = stopwords("english"), remove_punct = TRUE)
wordCount <- topfeatures(mydfm, 20)
textplot_wordcloud(mydfm, min.freq = min(wordCount), random.order = FALSE,
                   rot.per = .25, scale = c(3.5,0.2),
                   colors = RColorBrewer::brewer.pal(8,"Dark2"))
