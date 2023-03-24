#CITS4009 - Project one 2021
#Ali Alhasan 22166122

#Introduction 
# The dataset titled "US Consumer Finance Complaints" will be analysed for this project and it is published for the public on Kaggle platform. (Refer to link below)
# https://www.kaggle.com/cfpb/us-consumer-finance-complaints
# This dataset had been created by The Consumer Financial Protection Bureau (CFPB) in 2013 and then updated two years ago in 2019. 
# CFPB is an american government regulator agency that is responsible for protecting consumers in the financial sector, which includes banks, debt collectors, securities and exchange institutions and payday lenders.
# The dataset includes more than 555,000 consumer complaints received by the CFPB within XX years from different states around the US and against different products and firms. 


#Library Loading: 
library(tidyverse)
library(data.table)
library(magrittr)
library(ggplot2)
library(timeDate)
library(Hmisc)
library(scales)

#Loading dataset:

dat <- fread("consumer_complaints.csv")
attach(dat)
#Exploring the dataset:

str(dat)
# The dataset consists of 555957 ovservation by 18 variables (17 of which are characters and 1 is an integer). We can first notice that the date in the first column is listed in the form of month/day/year (american style) and that should be chnaged to day/month/year.Additionally, for the purpose of clarity, the states column can be rewritten as two columns containing eastern and western states. Likewise, the sybmitted_via column can also have degital submission which includes(email and website). However, we will be looking into that next. 


summary(dat)

# as for now, the summary function does not tell us much as the variables are characters and only the complaint_id is an integer. Yet, this is a unique number to identify each consumer complaint and hence details about quantiles and mean are irrelevant. 

head(dat)

# From the head function, we notice that the sub_product and sub_issue columns are missing some data as well as consumer_complaint_narraitive and company_public_response. However, we won't be focusing on the latest two as they deal with texts.



#Data Cleaning and Transformation: 


q1 <- c("1","2","3")
q2 <- c("4","5","6")
q3 <- c("7","8","9")
q4 <- c("10","11","12")

north_east <- c("ME", "VT", "NH", "MA", "CT","RI", "NY", "PA", "NJ")
southern <- c("MD", "DE", "WV", "VA", "NC", "SC", "GA", "FL", "KY","TN", "AL", "MS", "OK", "AR", "LA", "TX")
midwest <- c("WI", "MI", "IL", "IN", "OH", "ND","MN", "SD", "IA","NE", "KS", "MO")
west <- c("MT", "WY", "ID", "NV", "UT", "CO", "AZ", "NM", "WA", "OR", "CA") 


dat2 <- dat %>%
  mutate(date_received =  as.Date(date_received, "%m/%d/%Y"),
         date_sent_to_company = as.Date(date_sent_to_company, "%m/%d/%Y")) %>%
  mutate(days_processing = as.numeric(difftime(date_sent_to_company, date_received, units ="days"))) %>%
  filter(days_processing >= 0) %>%
  mutate(year = format(date_received, format="%Y"),     # make year column 
         month = as.character(as.numeric(format(date_received, format="%m")))) %>%  # make month column 
  mutate(quarter = case_when(month %in% q1 ~ "Q1",
                             month %in% q2 ~ "Q2",
                             month %in% q3 ~ "Q3",
                             month %in% q4 ~ "Q4")) %>%
  mutate(number_of_complaints = as.numeric(length(unique(dat$complaint_id)))) %>%
  mutate(disputed = if_else(`consumer_disputed?` == "Yes", TRUE, FALSE)) %>% 
  mutate(consumer_consent_provided = ifelse(consumer_consent_provided =="" | consumer_consent_provided == "Other","Unknown" ,consumer_consent_provided)) %>%
  dplyr::select(- tags, - consumer_complaint_narrative, -company_public_response)  %>% # drop columns
  filter(state %in% north_east | state %in% southern | state %in% midwest | state %in% west ) %>% 
  mutate(state_in = case_when(state %in% north_east ~ "The North East Region",
                              state %in% west ~ "The West Region",
                              state %in% midwest ~ "The Midwest Region",
                              state %in% southern ~ "The South Region")) 


dat2 %>% 
  group_by(submitted_via) %>% 
  summarise(freq = n(),
            mean = mean (days_processing), 
            min = min(days_processing), 
            max = max(days_processing), 
            median = median(days_processing))

dat2 %>% 
  group_by(product) %>% 
  summarise(freq = n(),
            mean = mean (days_processing), 
            min = min(days_processing), 
            max = max(days_processing), 
            median = median(days_processing))

dat2 %>% 
  group_by(year) %>% 
  summarise(freq = n(),
            mean = mean (days_processing), 
            min = min(days_processing), 
            max = max(days_processing), 
            median = median(days_processing))



worst_ten_companies <- sort(table(company), decreasing = TRUE) [1:10]


apply(is.na(dat2), 2, sum)

apply((dat2= ""), 2, sum)



#Visualisation & Report Quality:



#products vs year  - (correct)
ggplot(dat2, aes(x=dat2$year, y=dat2$product, color = dat2$year)) +
  geom_count(
    mapping = NULL,
    data = NULL,
    stat = "sum",
    position = "identity",
    na.rm = FALSE,
    show.legend = c(size = FALSE),
    inherit.aes = TRUE) +
  labs(title =  "Top Product Complaints by Year", x = "Year" , y="Product", size ="", color = "")


# processing time by state region. scaled by number of complaints. ask sadiq.
ggplot(dat2, mapping=aes(x=dat2$state_in, y=dat2$days_processing/dat2$number_of_complaints))+
  geom_bar(stat="identity" , fill="gray") +
  coord_flip()+ 
  labs(title =  "Average Processing Time in Each State Region", x = "State Region" , y="Average Processing Time", size ="")


#Processing time of submission method.

dat2 %>% 
  group_by(submitted_via) %>%
  ggplot(aes(days_processing)) +
  geom_histogram(binwidth = 1) +
  xlim(-1,10) +
  facet_wrap(~ submitted_via, scales = "free") +
  labs(title =  "Days to Process Complaints For Every Submission Method", x = "Days to Process" , y="Counts", size ="")


#disputes by state_in - (correct)

ggplot(dat2, aes(x = dat2$state_in, fill = dat2$disputed)) +
  geom_bar(position = "stack") +
  theme(legend.title = element_blank()) +
  labs(title = "Disputes For Each State Region" , x = "State Region", y= "Disputed")

# year by submission via (correct)
dat2 %>% 
  ggplot(mapping = aes(x = dat2$year, fill = dat2$submitted_via)) +
  geom_bar(position = "dodge") +
  theme(legend.title = element_blank()) +
  labs(title = "Submission Method VS Year" , x = "Year", y= "Submission method")


# number of complaints by year - see if you can fix the actual number of complaints on y-axis. 
ggplot(dat3, mapping = aes(x=dat3$year, y=dat3$complaint_id))+
  geom_point() +
  coord_flip()


#product vs state in (correct)
ggplot(dat2, aes(x=dat2$state_in, y=dat2$product, color = dat2$state_in)) +
  geom_count(
    mapping = NULL,
    data = NULL,
    stat = "sum",
    position = "identity",
    na.rm = FALSE,
    show.legend = c(size = FALSE),
    inherit.aes = TRUE) +
  facet_grid(. ~ dat2$number_of_complaints) +
  labs(title =  "Products by State Region", x = "State Region" , y="Product", size ="", color = "")
  