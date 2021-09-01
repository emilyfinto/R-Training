library(tidyverse)
library(nycflights13)

view(flights)
##dplyr basics - filter
filter(flights, month==1, day==1)
###dplyr functions do not save new data, so...
(jan1 <- filter(flights, month==1, day==1))

##filter with boolean operations
filter(flights, month==11 | month==12)
###shorthand
(nov_dec <- filter(flights, month %in% c(11,12)))
filter(flights, !(arr_delay>120 | dep_delay>120))

###Exercises
filter(flights, arr_delay>=120)
filter(flights, dest=="IAH" | dest=="HOU")
filter(flights, dest %in% c("IAH","HOU"))
filter(flights, carrier %in% c("AA","UA","DL"))
filter(flights, arr_delay>120,dep_delay<=0)

##dplyr basics - arrange
arrange(flights, year, month, day)
arrange(flights, desc(dep_delay))

##dplyr basics - select
select(flights, year, month, day)
select(flights, contains("TIME"))
select(flights, contains("TIME", ignore.case=FALSE))

##dplyr basics - mutate
flights_sml <- select(flights,
    year:day,
    ends_with("delay"),
    distance,
    air_time
)
mutate(flights_sml,
    gain = dep_delay - arr_delay,
    speed = distance / air_time*60
)
view(flights_sml)
transmute(flights_sml,
    gain = dep_delay - arr_delay,
    hours = air_time/60,
    gain_per_hour = gain/hours
)
view(flights_sml)

##dplyr basics - summarize
summarize(flights, delay = mean(dep_delay, na.rm=TRUE))
###summarize() is usually more helpful with group_by()
by_day <- group_by(flights, year, month, day)
summarize(by_day, delay=mean(dep_delay, na.rm=TRUE))

##application example
by_dest <- group_by(flights, dest)
delay <- summarize(by_dest,
      count=n(),
      dist=mean(distance, na.rm=TRUE),
      delay=mean(arr_delay, na.rm=TRUE)
)
delay <- filter(delay, count>20, dest != "HNL")
ggplot(delay, aes(x=dist, y=delay))+
  geom_point(aes(size=count), alpha=1/3)+
  geom_smooth(se=FALSE)
###OR, simplify
delays <- flights %>%
    group_by(dest) %>%
    summarize(
      count=n(),
      dist=mean(distance, na.rm=TRUE),
      delay=mean(arr_delay, na.rm=TRUE),
    ) %>%
    filter(count>20, dest!="HNL")

##dealing with missing values
(not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay)))
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(mean=mean(dep_delay))

##include a count in your analysis to make sure you're not drawing conclusions on a small n
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay)
  )
ggplot(delays, aes(x=delay))+
  geom_freqpoly(binwidth=10)

###do instead...
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay, na.rm=TRUE),
    n=n()
  )
ggplot(delays, aes(x=n, y=delay))+
  geom_point(alpha=1/10)

###and fix...
delays %>%
  filter(n>25) %>%
  ggplot(mapping=aes(x=n, y=delay))+
  geom_point(alpha=1/10)

##grouping by multiple variables
daily <- group_by(flights, year, month, day)
(per_day <- summarize(daily, flights=n()))
(per_month <- summarize(per_day, flights=sum(flights)))
(per_year <- summarize(per_month, flights=sum(flights)))
###ungrouping
daily %>%
  ungroup() %>%
  summarize(flights=n())
