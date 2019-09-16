---
title: "Exploring the BRFSS data"
output: 
  html_document: 
    fig_height: 4
    highlight: pygments
    theme: spacelab
---

## Setup

### Load packages

```{r load-packages, message = FALSE}
library(ggplot2)
library(dplyr)
library(corrplot)
```

### Load data

```{r load-data}
load("brfss2013.RData")
```



* * *

## Part 1: Data

The Behavioral Risk Factor Surveillance System (BRFSS) is a system of phone-surveys that collect data from U.S. residents on their health-related risk behaviors, chronic health conditions, and use of preventive services. Data is collected from all 50 states as well as the District of Columbia, Guam, Puerto Rico, and the U.S. Virgin Islands. BRFSS is the largest continuously conducted health survey system in the world.

We can learn about the sampling methods from the [BRFSS Data User Guide](http://www.cdc.gov/brfss/data_documentation/pdf/userguidejune2013.pdf). In order
to conduct the BRFSS, states obtain samples of telephone numbers from CDC. The BRFSS uses
two samples: one for landline telephone respondents and one for cellular telephone respondents. Since landline telephones are often shared among persons living within a residence, household sampling is used in the landline sample. Household sampling requires interviewers to collect information on the number of adults living within a residence and then select randomly from all eligible adults. Cellular telephone respondents are weighted as single adult households. 

For the landline sample, disproportionate stratified sampling (DSS) is used for sampling telephone numbers and is more efficient than simple random sampling. The cellular telephone sample is randomly generated from a sampling frame of confirmed
cellular area code and prefix combinations.

### Generalizability

As it stands, the BRFSS should generalize to all adults (18-years and older) who are household members since the phone numbers are selected by some form of random sampling. The user guide notes that other nations are setting up similar surveys. However, we should not try to generalize to the global adult population for a variety of reasons. In particular, the access to landlines and cellular telephones is not similar from country to country.

### Causality

The BRFSS data is observational not experimental. Even though the phone numbers are randomly selected, the subjects are *not* randomly assigned to experimental study groups. Therefore, we can only show a correlation/association, not a causation.




* * *

## Part 2: Research questions

**Research quesion 1:**

Is there a correlation between not having poor physical health `physhlth` and mental health `menthlth`? Are there differences based on gender 'sex'?

This would be a preliminary data exploration to examine the question of whether there is an association between physical illness and mental illness.

**Research quesion 2:**

Is there a correlation between hours of sleep `sleptim1` and poor mental health `menthlth`?
We look at this by employment status `employ1`.

We could look for an association between hours slept and poor mental health. We will look for patterns based on employment status.

**Research quesion 3:**

Is there a correlation between reported general health `genhlth` and hours of sleep `sleptim1` based on gender `sex`?


We can examine the question of whether 7 or 8 hours of sleep per night is better for you.

* * *

## Part 3: Exploratory data analysis



**Research quesion 1:**

```{r}
set1 <- select(brfss2013, menthlth, physhlth, sleptim1, X_bmi5, nummen, numwomen, employ1, sex) %>%
   filter(menthlth != "NA") %>% filter(physhlth != "NA") %>% filter(sleptim1 != "NA") %>% filter(X_bmi5 != "NA") %>% filter(nummen != "NA") %>% filter(numwomen != "NA") %>% filter(employ1 != "NA") %>% filter(sex != "NA")
summary(set1)
g <- ggplot(set1, aes(physhlth, menthlth))
g + geom_point(shape = 19, alpha = 1/2,aes(colour = sex)) + geom_smooth(color = "green") + facet_grid(.~sex) + theme_bw()
```

It is interesting to note that the shapes of the smoothing curves are very similar. Both have the same numbers of peaks and valleys. 


**Research quesion 2:**

```{r}
p <- ggplot(set1, aes( menthlth, X_bmi5))
p + geom_point(shape = 19, alpha = 1/2,aes(colour = employ1)) + geom_smooth(color = "green")  + facet_grid(.~sex) + theme_bw()
```

For both males and females there appears to be a slight positive correlation.

**Research quesion 3:**

```{r}
set2 <- select(brfss2013,  sex, menthlth, genhlth, sleptim1) %>% filter(sex != "NA") %>% 
  filter(menthlth != "NA") %>% filter(genhlth != "NA") %>% filter(sleptim1 <= 12)
summary(set2)
q <- ggplot(set2, aes(genhlth, sleptim1))
q + geom_boxplot() + scale_y_continuous(limits = c(4,10), breaks = 5:9) + facet_grid(. ~ sex) + xlab("genhlth = Self reported general health") + 
  ylab ("sleptim1 = How much time do you sleep?") + theme_bw()
```

There appear to be no significant differences between men and women, although (self-reported) healthy women appear to need less sleep.