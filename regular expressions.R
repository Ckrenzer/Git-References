# INTRO --------------------------------------------
# This tutorial goes through the basics of regular expressions in R.

# Wikipedia: "A regular expression ... is a sequence of characters
# that define a search pattern.


# Regular expressions are essentially the same across languages,
# so once you learn it in one language you will be able to
# use them in others.

# They are particularly useful in find and replace operations.


# PACKAGES ---------------------------------------
if(!require(pacman)) install.packages("pacman")
pacman::p_load(dplyr, rvest, stringr, purrr)



# DATA ------------------------------------------
# For simplicity's sake, I will collect some data for you.
# If you do not know how to do web scraping, follow this
# link to my GitHub repo: <>


# This data comes from a goodreads poll about which
# Orwell books people in a discussion group wanted
# to talk about.

url <- "https://www.goodreads.com/poll/show/166613-our-theme-for-march-2018-is-the-author-a-george-orwell-3706-george-orwe"
webpage <- read_html(url)
webpage_nodes <- html_nodes(webpage, ".answerLabel , .answerLabelHolder+ div .smallText")
text <- html_text(webpage_nodes)




# This is what we want the final result to look like
## (don't worry about the code, just take a peek at
## the results)


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

str_split(txt_fix, pattern = "\\s?(votes?),\n(\\s*)")

