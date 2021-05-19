# INTRO --------------------------------------------
# This tutorial goes through the basics of regular expressions in R.

# Wikipedia says: "A regular expression ... is a sequence of characters
# that define a search pattern."


# Regular expressions are essentially the same across languages,
# so once you learn it in one language you will be able to
# use them in others.

# They are particularly useful in find and replace operations.




# PACKAGES ---------------------------------------
if(!require(pacman)) install.packages("pacman")
pacman::p_load(dplyr, rvest, stringr, purrr, tidyr, readr)







# DATA ------------------------------------------
# For simplicity's sake, I will collect some data for you.
# If you do not know how to do web scraping, follow this
# link to my web scraping tutorial: https://www.youtube.com/watch?v=QYRqdH_9Yl8&list=PLU_CBDm5DXxVzGdGvaegyCMl6KDm36Gcv&index=1&t=156s


# This data comes from a goodreads poll about which
# Orwell books people in a discussion group wanted
# to talk about.

url <- "https://www.goodreads.com/poll/show/166613-our-theme-for-march-2018-is-the-author-a-george-orwell-3706-george-orwe"
webpage <- read_html(url)
webpage_nodes <- html_nodes(webpage, ".answerLabel , .answerLabelHolder+ div .smallText")
text <- html_text(webpage_nodes)









# CLEANING --------------------------------------
# What does out text look like after reading it in:
text

#     ## As an aside, know that most of this work is taken care of with str_split(text, "\n", simplify = TRUE)
#     ## but the purpose of this tutorial is to work with regular expressions

# Let's remove the white space:
txt_fix <- str_trim(text)

# Let's see what we have now:
txt_fix
# It's a character vector:
class(txt_fix)


# We cannot use parse_number() because we need both the
# number of votes and the percent sign


# We will need to split up the votes and percents
# according to a metric. How do we determine the rule
# to split up the strings? In this case, we can almost
# hard-code the solution. Let's take a look:
str_view(txt_fix, pattern = " votes,")

# But you're thinking, "why didn't you add the space after
# the comma?" Let's see what happens here:
str_view(txt_fix, pattern = " votes, ")

# Clearly, then, another solution is required...
# How do we account for that extra space?


# The answer is simple: REGULAR EXPRESSIONS!


# We can use regular expressions to account for the
# missing white space
str_view(txt_fix, pattern = "\\s*(votes?),\n(\\s*)")

# This is close--now we just need a way to combine everything
txt_fix <- str_split(txt_fix, pattern = "\\s?(votes?),\n(\\s*)")



# Making a vector to store all the values
txt_data <- vector(length = 0L)
txt_data[1] <- txt_fix[[1]]

# I really don't like the nested loop structure: surely someone has come up with a way around this...
# Regardless, working with lists that are not the same length is a topic for another day. What
# we care about now is that this works:
for(i in 2:length(txt_fix)){
 for(j in 1:length(txt_fix[[i]])){
   txt_data <- c(txt_data, txt_fix[[i]][j])
 }
}





# making separate vectors for each variable
title <- txt_data[str_detect(txt_data, "^[a-zA-Z]+|1984")]
votes <- txt_data[str_detect(txt_data, "^\\d$")]
rating <- txt_data[str_detect(txt_data, "%$")]

# combining the variables into a data frame
txt_data_tidy <- data.frame(title, votes, rating)


# Now we need to change the data types from characters into something more useful
# parse_number() is very similar to as.numeric(), but pulls out any number in the
# input instead of requiring the string to be formatted properly beforehand:
txt_data_tidy$votes <- parse_number(txt_data_tidy$votes)
txt_data_tidy$rating <- parse_number(txt_data_tidy$rating)


# Let's take a look at the tidy data frame:
tibble(txt_data_tidy)

