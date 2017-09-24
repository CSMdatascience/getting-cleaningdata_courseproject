# README - run_analysis.R

This script does the following:

1. Downloads zipped data from UCI machine learning repository (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

2. Extracts zipped data

3. Reads pre-processed data into R (i.e. everything but the raw accelerometer and gyro data)

4. Constructs a data frame of all pre-processed data with descriptive labels

5. Takes the subset of this data containing "mean" or "standard deviation" values

6. Creates a new data frame containing only the mean of every measured variable in the full data set

