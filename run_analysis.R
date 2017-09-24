##run_analysis.R

##load reshape library so we can use melt()
library(reshape)

##download and extract the dataset
file_zip <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = "UCI HAR dataset.zip")
unzip(zipfile = "UCI HAR dataset.zip")

##read "activity_labels.txt" and "features.txt" into data frames
activity_labels <- read.table("UCI HAR dataset/activity_labels.txt")
all_features <- read.table ("UCI HAR dataset/features.txt")

##these tables are indexed column names
##remove the column names and place them in a character vector
activity_labels_names <- as.character(activity_labels[,2])
all_features_names <- as.character(all_features[,2])

##extract only the column names associated with "mean" or "std" 
features <- grep(".*mean.*|.*std.*", all_features_names)
features_names <- all_features[features,2]

##tidy the naming conventions
features_names = gsub('-mean', '_MEAN_', features_names)
features_names = gsub('-std', '_STD_', features_names)
features_names <- gsub('[-()]', '', features_names)

##read "t" and "train" subsets into data frames
test_x <- read.table("UCI HAR dataset/test/X_test.txt")[features]
test_activity <- read.table("UCI HAR dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR dataset/test/subject_test.txt")

train_x <- read.table("UCI HAR dataset/train/X_train.txt")[features]
train_activity <- read.table("UCI HAR dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR dataset/train/subject_train.txt")

##merge the subsets into complete "test" and "train" data frames
        ##put identifiers ("subject" and "activity") first
test <- cbind(test_subjects, test_activity, test_x)
train <- cbind(train_subjects, train_activity, train_x)

##merge "test" and "train" datasets
data <- rbind(test, train)

##add the column names - remembering, "subject" and "activity" 
##have been moved all the way to the left
colnames(data) <- c("SUBJECT", "ACTIVITY", features_names)

##convert "ACTIVITY" class to factor, and
##replace numerioc indices with descriptive strings
data[,2] <- factor(data[,2], levels = activity_labels[,1], 
                      labels = activity_labels[,2])

##convert "SUBJECT" class to factor
data[,1] <- as.factor(data[,1])

##melt data by "SUBJECT" and "ACTIVITY"
data_melt <- melt(data, id = c("SUBJECT", "ACTIVITY"))
data_melt_mean <- cast(data_melt, SUBJECT + ACTIVITY ~ variable, mean)

##write table of average values
data_mean <- write.table(data_melt_mean, "data_mean.txt", row.names = F, quote = F)

##store this table in R
data_mean <- read.table("data_mean.txt")
