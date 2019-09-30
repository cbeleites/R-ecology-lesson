
### Creating objects in R

















### Challenge
##
## What are the values after each statement in the following?
##
## mass <- 47.5            # mass?
## age  <- 122             # age?
## mass <- mass * 2.0      # mass?
## age  <- age - 20        # age?
## mass_index <- mass/age  # mass_index?















### Vectors and data types





















#> ## We’ve seen that atomic vectors can be of type character, numeric, integer, and
#> ## logical. But what happens if we try to mix these types in a single
#> ## vector?
#> 
#> ## What will happen in each of these examples? (hint: use `class()` to
#> ## check the data type of your object)
#> num_char <- c(1, 2, 3, "a")
#> 
#> num_logical <- c(1, 2, 3, TRUE)
#> 
#> char_logical <- c("a", "b", "c", TRUE)
#> 
#> tricky <- c(1, 2, 3, "4")
#> 
#> ## Why do you think it happens?
#> 
#> ## You've probably noticed that objects of different types get
#> ## converted into a single, shared type within a vector. In R, we call
#> ## converting objects from one class into another class
#> ## _coercion_. These conversions happen according to a hierarchy,
#> ## whereby some types get preferentially coerced into other types. Can
#> ## you draw a diagram that represents the hierarchy of how these data
#> ## types are coerced?















### Challenge (optional)
##
## * Can you figure out why `"four" > "five"` returns `TRUE`?







## ### Challenge
## 1. Using this vector of heights in inches, create a new vector with the NAs removed.
##
##    heights <- c(63, 69, 60, 65, NA, 68, 61, 70, 61, 59, 64, 69, 63, 63, NA, 72, 65, 64, 70, 63, 65)
##
## 2. Use the function `median()` to calculate the median of the `heights` vector.
##
## 3. Use R to figure out how many people in the set are taller than 67 inches.
### Presentation of the survey data

#> download.file(url="https://ndownloader.figshare.com/files/2292169",
#>               destfile = "data_raw/portal_data_joined.csv")












## Challenge
## Based on the output of `str(surveys)`, can you answer the following questions?
## * What is the class of the object `surveys`?
## * How many rows and how many columns are in this object?
## * How many species have been recorded during these surveys?



## Extracting vectors from data frames



### Factors

sex <- factor(c("male", "female", "female", "male"))







year_fct <- factor(c(1990, 1983, 1977, 1998, 1990))
as.numeric(year_fct)               # Wrong! And there is no warning...
as.numeric(as.character(year_fct)) # Works...
as.numeric(levels(year_fct))[year_fct]    # The recommended way.

## bar plot of the number of females and males captured during the experiment:
plot(surveys$sex)





## Challenges
##
## * Rename "F" and "M" to "female" and "male" respectively.
## * Now that we have renamed the factor level to "undetermined", can you recreate the
##   barplot such that "undetermined" is last (after "male")
#> ## Pipes Challenge:
#> ##  Using pipes, subset the data to include animals collected
#> ##  before 1995, and retain the columns `year`, `sex`, and `weight.`











#> ## Mutate Challenge:
#> ##  Create a new data frame from the `surveys` data that meets the following
#> ##  criteria: contains only the `species_id` column and a new column called
#> ##  `hindfoot_cm` containing the `hindfoot_length` values converted to centimeters.
#> ##  In this `hindfoot_cm` column, there are no `NA`s and all values are less
#> ##  than 3.
#> 
#> ##  Hint: think about how the commands should be ordered to produce this data frame!

































#> ## Count Challenges:
#> 
#> ##  1. Find out where the `n` is coming from, by reading the help pages of the above functions.
#> 
#> ##  2. How many animals were caught in each `plot_type` surveyed?
#> 
#> ##  3. Use `group_by()` and `summarize()` to find the mean, min, and max
#> ## hindfoot length for each species (using `species_id`). Also add the number of
#> ## observations (hint: see `?n`).
#> 
#> ##  4. What was the heaviest animal measured in each year? Return the
#> ##  columns `year`, `genus`, `species_id`, and `weight`.



















#> ## Reshaping challenges
#> 
#> ## 1. Spread the `surveys` data frame with `year` as columns, `plot_id` as rows, and the number of genera per plot as the values. You will need to summarize before reshaping, and use the function `n_distinct()` to get the number of unique genera within a particular chunk of data. It's a powerful function! See `?n_distinct` for more.
#> 
#> ## 2. Now take that data frame and `gather()` it again, so each row is a unique `plot_id` by `year` combination.
#> 
#> ## 3. The `surveys` data set has two measurement columns: `hindfoot_length` and `weight`. This makes it difficult to do things like look at the relationship between mean values of each measurement per year in different plot types. Let's walk through a common solution for this type of problem. First, use `gather()` to create a dataset where we have a key column called `measurement` and a `value` column that takes on the value of either `hindfoot_length` or `weight`. *Hint*: You'll need to specify which columns are being gathered.
#> 
#> ## 4. With this new data set, calculate the average of each `measurement` in each `year` for each different `plot_type`. Then `spread()` them into a data set with a column for `hindfoot_length` and `weight`. *Hint*: You only need to specify the key and value columns for `spread()`.





#> ### Create the dataset for exporting:
#> ##  Start by removing observations for which the `species_id`, `weight`,
#> ##  `hindfoot_length`, or `sex` data are missing:
#> surveys_complete <- surveys %>%
#>     filter(species_id != "",        # remove missing species_id
#>            !is.na(weight),                 # remove missing weight
#>            !is.na(hindfoot_length),        # remove missing hindfoot_length
#>            sex != "")                      # remove missing sex
#> 
#> ##  Now remove rare species in two steps. First, make a list of species which
#> ##  appear at least 50 times in our dataset:
#> species_counts <- surveys_complete %>%
#>     count(species_id) %>%
#>     filter(n >= 50) %>%
#>     select(species_id)
#> 
#> ##  Second, keep only those species:
#> surveys_complete <- surveys_complete %>%
#>     filter(species_id %in% species_counts$species_id)
### Data Visualization with ggplot2



































#> ## Challenge with boxplots:
#> ##  Start with the boxplot we created:
#> ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
#>   geom_boxplot(alpha = 0) +
#>   geom_jitter(alpha = 0.3, color = "tomato")
#> 
#> ##  1. Replace the box plot with a violin plot; see `geom_violin()`.
#> 
#> ##  2. Represent weight on the log10 scale; see `scale_y_log10()`.
#> 
#> ##  3. Create boxplot for `hindfoot_length` overlaid on a jitter layer.
#> 
#> ##  4. Add color to the data points on your boxplot according to the
#> ##  plot from which the sample was taken (`plot_id`).
#> ##  *Hint:* Check the class for `plot_id`. Consider changing the class
#> ##  of `plot_id` from integer to factor. Why does this change how R
#> ##  makes the graph?
#> 

























#> ### Plotting time series challenge:
#> ##
#> ##  Use what you just learned to create a plot that depicts how the
#> ##  average weight of each species changes through the years.
#> 









#> install.packages("gridExtra")





#> ### Final plotting challenge:
#> ##  With all of this information in hand, please take another five
#> ##  minutes to either improve one of the plots generated in this
#> ##  exercise or create a beautiful graph of your own. Use the RStudio
#> ##  ggplot2 cheat sheet for inspiration:
#> ##  https://www.rstudio.com/wp-content/uploads/2015/08/ggplot2-cheatsheet.pdf

