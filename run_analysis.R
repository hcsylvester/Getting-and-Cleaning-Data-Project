#Getting and Cleaning Data Course Project
#HCS
#load packages needed for project
install.packages("data.table")
install.packages("reshape2")
install.packages("dplyr")

library(data.table)
library(reshape2)
library(dplyr)

#load data given
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "DataF.zip")
unzip("DataF.zip")

#load activity labels, features, subject test and train data
act <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("Indicator", "activity"))
feat <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

#load test x and y data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = feat$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Indicator")

#load train x and y data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = feat$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Indicator")

#combining all x test and train data into one variable
x_variables <- rbind(x_test, x_train)

#combining all y test and train data into one variable
y_variables <- rbind(y_test, y_train)

#combining all subject test and train data into one variable
sub_data <- rbind(sub_test, sub_train)

#merge datasets
merge_complete <- cbind(sub_data, x_variables, y_variables)

#Use a pipeline command to make data even more tidy 
NarrowData <- merge_complete %>% select(subject, Indicator, contains("mean"), contains("std"))

#Create describptive activity names to name the activities in the data set
NarrowData$Indicator <- act[NarrowData$Indicator, 2]
names(NarrowData)[2] = "activity"
names(NarrowData) <- gsub("Acc", "Accelerometer", names(NarrowData))
names(NarrowData) <- gsub("Gyro", "gyroscope", names(NarrowData))
names(NarrowData) <- gsub("Mag", "Magnitude", names(NarrowData))
names(NarrowData) <- gsub("tBody", "TimeBody", names(NarrowData))
names(NarrowData) <- gsub("-mean", "Mean", names(NarrowData), ignore.case = TRUE)
names(NarrowData) <- gsub("-std", "StandardDeviation", names(NarrowData), ignore.case = TRUE)
names(NarrowData) <- gsub("-freq", "Frequency", names(NarrowData), ignore.case = TRUE)
names(NarrowData) <- gsub("^f", "Frequency", names(NarrowData))
names(NarrowData) <- gsub("angle", "Angle", names(NarrowData))
names(NarrowData) <- gsub("BodyBody", "Body", names(NarrowData))
names(NarrowData) <- gsub("^t", "Time", names(NarrowData))
names(NarrowData) <- gsub("angle", "Angle", names(NarrowData))

#Final step - creating a second tidy data set including only average of each variable for each activity and subject.  
step_5 <- aggregate(. ~ subject + activity, data = NarrowData, FUN = mean)

#writes file into working directory
write.table(step_5, "Step_5.txt", row.name = TRUE)
