# Data cleaning, transformation and Visualisation in R - US Consumer Finance Complaints dataset.


The US Consumer Finance Complaints dataset by the Consumer Financial Protection Bureau (CFPB) contains detailed information about consumer complaints related to various financial products and services in the United States. The dataset covers the year 2013 and includes over 555,000 records.

The complaints were filed by consumers through the CFPB's Consumer Complaint Database, an online portal where consumers can submit complaints about financial products and services, such as credit cards, mortgages, student loans, and payday loans. The database allows consumers to provide detailed information about their complaints, including the company or institution involved, the type of product or service, and the nature of the problem.

## Project Deliverables & Objectives: 

The project was performed in R using different libraries such as tidyverse, ggplot2, dplyr and data.table packages. The goal of the project was to clean and transform the data to make it easier to analyse and visualise.

### The Data Cleaning Process: 

The data was initially in a raw format and contained missing values, incorrect data types, and inconsistent values. The following steps were taken to clean the data:

• Renamed columns to make them more descriptive.
• Converted date columns to the appropriate date format.
• Converted categorical variables to the factor data type.
• Removed unnecessary columns.
• Handled missing values by either removing rows or imputing values.
• Corrected inconsistent values.

### Data Transformation
The data transformation process includes several transformations that were performed to prepare the data for further analysis. These transformations included:

• Grouping the data by state regions and months by quarters to calculate the total number of complaints in different regions overtime. 
• Creating a new columns to identify the year the complaint were received, and whether they have been disputed and consented. 
• Reformatting the data to a long format for easier analysis and visualization

### Data Visualization
After cleaning  and transforming the data, several visualizations were created to explore the dataset. The visualizations were created using the ggplot2 package and included:

• A heat map showing the number of complaints by product.
• A bar chart showing the average processing time by state region.
• A histogram showing the number of days to process complaints by different submission methods (Email, Fax, Phone, Postal mail, Referral and Web)
• A barplot to show the number of disputed complaints by state region. 
• A line graph of number of complaints by product over year.
• A pie chart showing the share of complaints to each year. 
