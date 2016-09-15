## Tidy data concept
## Because this has the animals spread across three columns this is not considered tidy data. 
## Otherwise this table is tidy. 

counts_df <- data.frame(
  day = c("Monday", "Tuesday", "Wednesday"),
  wolf = c(2, 1, 3),
  hare = c(20, 25, 30),
  fox = c(4, 4, 4)
)

## Reshaping multiple columns in category/value pairs
## new column is species that combines the animals with the count in the third column. 
library(tidyr)
counts_gather <- gather(counts_df, 
                        key = "species",
                        value = "count",
                        wolf:fox)

## Since the species and count are now column names we don't need to use ""
counts_spread <- spread(counts_gather, 
                        key = species,
                        value = count)

## Exercise 1

counts_gather[-1,]->small_counts_gather

##instead of having an NA for the missing wolf observation we can add in a 0 that reflects that 
##no wolves were observed, which is more accurate than NA
small_counts_spread <- spread(small_counts_gather, 
                        key = species,
                        value = count,
                        fill=0)

## Read comma-separated-value (CSV) files

## na.strings="" does not count NAs as a category
surveys <- read.csv("data/surveys.csv",na.strings="")

## Subsetting and sorting - can do as many as we want, just separate by comma. 

library(dplyr)
surveys_1990_winter <- filter(surveys,
                              year==1990,
                              month %in% 1:3)

##these two are the same, but the second one is more efficient
surveys_1990_winter <- select(surveys_1990_winter, record_id, month, day, plot_id,species_id, sex,hindfoot_length,weight)
surveys_1990_winter <- select(surveys_1990_winter, -year)

##sorting the data, default is ascending. can use head() to see the top and tail()to see the bottom of DF
sorted <- arrange(surveys_1990_winter, species_id, desc(weight))

## Exercise 2, first I removed all columns that were not needed using the select() function.
## Then I used filter to select for RO

surveys_RO <- select(surveys, -c(month, day, year, plot_id, hindfoot_length))
##or
surveys_RO <- select(surveys, record_id, sex, weight)
surveys_RO2 <- filter(surveys_RO, species_id=="RO")

##OR

surveys_RO2 <- select(filter(surveys, species_id=="RO"), record_id, sex, weight)

## can double check the results by using: 

count(surveys, species_id=="RO")

## Grouping and aggregation

surveys_1990_winter_gb <- group_by(surveys_1990_winter, species_id)
## count () is the count of rows in this case
counts_1990_winter <- summarize(surveys_1990_winter_gb, count = n())

## Exercise 3

surveys_3 <- select(filter(surveys,species_id=="DM"), weight, hindfoot_length, month)
##this groups the data by month! 
surveys_3_gb <- group_by(surveys_3, month)
##this gives the mean value for each month for weight and hindfoot length with NAs removed. 
surveys_3_gb_avg <- summarize(surveys_3_gb, hfl_avg=mean(hindfoot_length,na.rm=T),wgt_avg=mean(weight, na.rm=T))


## Pivto tables through aggregate and spread

surveys_1990_winter_gb <- group_by(surveys_1990_winter, ...)
counts_by_month <- ...(surveys_1990_winter_gb, ...)
pivot <- ...

## Transformation of variables

prop_1990_winter <- mutate(...)

## Exercise 4

...

## Chainning with pipes
## %>% is the pipe operator. it passes the argument on the left to the first argument on the right. saves lines of code. 

prop_1990_winter_piped <- surveys %>%
  filter(year == 1990, month %in% 1:3) %>%  
  select(-year) %>%  # select all columns but year
  group_by(species_id) %>% # group by species_id
  summarize(counts=n()) # summarize with counts
  ... # mutate into proportions
