if(!require(pacman)) install.packages("pacman")
pacman::p_load(stringr)


# Regular expressions are sequences of characters that define a search pattern.
# That's all there is to it.





# Square brackets [ ] ----------------------------------

# Anything contained between [] means "match anything contained 
# between these brackets"

# matches the "el" in "Hello"
str_view_all(string = "Helloe", pattern = "el")

# Read [el] as "match all instances of e or l in the string"
str_view_all(string = "Helloe", pattern = "[el]")




# You can use a hyphen to select multiple letters:
str_view_all(string = "Hello", pattern = "[a-i]")
# The line above highlights all lowercase letters a through i
# You'll have to use "[A-Z]" to highlight all uppercase letters
# or you can convert everything to lowercase



# This line highlights all digits 0 through 9
str_view_all(string = "H3llo 7654", pattern = "[0-9]")











# Special Characters -------------------------------

# The dot (period) means anything that is not a line break
str_view_all(string = "Hello.", pattern = ".")

# To use an actual period, you have to add a "\\" before the dot
str_view_all(string = "Hello.  .  .", pattern = "\\.")

# Newline characters (when you click the ENTER key)
str_view_all(string = "Hello
             there", pattern = "\n")


# \\s is a space character
str_view_all(string = "Hi, how are you?", pattern = "\\s")






# Quantifiers {}, +, ?, * --------------------------------------

# A plus sign means "one or more"
str_view_all(string = "Hello", pattern = "l+")
str_view_all(string = "Hello", pattern = "e+")
str_view_all(string = "Hello", pattern = "h+") # nothing highlighted (case-sensitive)



# Something followed by numbers encapsulated by "{}" are quantifiers
# {2} means the pattern appears exactly twice
# {2,4} means the pattern appears two, three, or four times
# {2,} means the pattern appears two or more times
str_view_all(string = "Helloe", pattern = "[el]{3}")


# The question mark, ?, is shorthand for 0 or 1 instance
# The asterisk, *, is shorthand for 0 or more instances




# Anchors ^, $ --------------------------
# There are other anchors out there, but just knowing the start of string and end of string anchors is very useful

# The caret, ^, means "the start of the string"
# The dollar sign, $, means "the end of the string"
# I don't know what to tell you if your keyboard doesn't
# have dollar signs on it, but I'd try whatever is
# on Shift+4


# Read this as "find all numbers between the start of the string
# and the first character that is not a digit"
str_view_all(string = "2021? Is that the 77year?", pattern = "^[\\d]*")

# Read this line as "find the word at the end of the string containing letters or !"
str_view_all(string = "Goodbye! It was nice seeing you!", pattern = "[a-zA-Z!]*$")



# Groups ( ) -------------------------------------------
# You can define groups of characters using parentheses
# Groups are most useful in replacement and extraction operations


# If you want to find the second "two" you might write the following code:
str_view_all(string = "one, two, three, two, one", pattern = "[a-z]*,\\s[a-z]*$")

# The inclusion of parentheses does not change the result of the match:
str_view_all(string = "one, two, three, two, one", pattern = "([a-z]*),\\s([a-z]*)$")



# to replace the comma with a semicolon in "two, one" we could do the following:
str_replace(string = "one, two, three, two, one",
            pattern = "([a-z]*),\\s*(one)",
            replacement = "\\1; \\2")

# \\1 means the first group enclosed in parentheses, \\2 means the second
# group enclosed in parentheses.

# What we just did was take the first group, "[a-z]*", and the second group,
# "[a-z]*$", and replace the entire expression "two, one" with the contents of
# the first group ("two"), a semicolon, a space, and the contents of the
# second group ("one").






# OR -----------------------------------------------
# If you have several different patterns, you
# can use the pipe, |, (not to be confused with the magrittr pipe)
# to match a string with multiple regular expressions


# If we want to highlight cases where "Jack" or "Jill" are
# found within the string, we can use the pipe to identify
# their names using only one statement
str_view_all(string = "Jack and Jill went up the hill.",
             pattern = "Jack|Jill")

# If we wanted to highlight "hill" in addition, we can do that too:
str_view_all(string = "Jack and Jill went up the hill.",
             pattern = "Jack|Jill|hill")
