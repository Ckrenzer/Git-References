# INTRO -----------------------------------
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# This tutorial has seven steps:                              #
#     1. install/load packages                                #
#     2. get the url                                          #
#     3. read in webpage                                      #
#     4. pull nodes off the webpage                           #
#     5. convert data from the nodes into a usable format     #
#     6. clean the data                                       #
#     7. Analyze                                              #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #




# PACKAGES (Step 1) ---------------------------------
if(!require(pacman)) install.packages("pacman")
pacman::p_load(rvest, dplyr, readr, tidyr, stringr)


# READING IN DATA (Steps 2-5) ------------------------------------
# We want the url as a String
url <- "https://en.wikipedia.org/wiki/List_of_largest_companies_by_revenue"

# We then want to load in the webpage using read_html()
webpage <- read_html(url)

# Next, we want to pull the html nodes from the webpage we just read in
nodes <- html_nodes(webpage, "td")

# Finally, we can take the nodes and store them as a character vector
text <- html_text(nodes)[1:350]

text[1:21]


# CLEANING DATA (Step 6) ---------------------------------
# Creating vectors for each of the variables we want to keep
name <- text[seq(1, 350, by = 7)]
industry <- text[seq(2, 350, by = 7)]
revenue <- text[seq(3, 350, by = 7)]
profit <- text[seq(4, 350, by = 7)]
employees <- text[seq(5, 350, by = 7)]
country <- text[seq(6, 350, by = 7)]

# Making a tibble from the vectors
companies <- tibble(name, industry, revenue, profit, employees, country)


# Let's take a look at the entire table
companies %>% as.data.frame()




# Now, let's remove the newline characters
# and make the quantitative columns numeric

# removing newlines and whitespace
companies <- as_tibble(sapply(companies, str_trim))



# converting from Strings to numeric types
# parse_number() does not work on the profit column,
# so the dollar signs will need to be removed manually

# using a loop function to convert the columns that parse_number can handle
companies[, c(3, 5)] <- vapply(companies[, c(3, 5)], parse_number, numeric(50))

companies$profit <- as.numeric(str_replace_all(companies$profit, "^(-?)[$?](\\d*),*(\\d*)$", "\\1\\2\\3"))








# ANALYZE (Step 7) ------------------------------------
# The data is now ready for use!

# How many companies have more than 100,000 employees?
companies %>% 
  filter(employees > 100000) %>% 
  count()

# 36 out of 50 companies have more than 100,000
# employees