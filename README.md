# Cleaning-Data-Week4
Week 4 data project for the Getting and Cleaning Data course. 

run_analysis.R:

* combines training and test data into one
* combines subject, activity, and measurements data
* selects only measurements that reflected mean or std; the rest are discarded
* replaces activity id with activity label
* labels the data set with descriptive variable names
* creates tidy set of the mean value of each variable for each subject and activity pair
* saves the resulting data in tidyData.txt file
