## PA 1: Getting and Cleaning Data
##
## run_analysis.R
##
## Version / Date:     1.0.0 / 1-25-2015
## 

## The data link from the course website represent data collected from the 
## accelerometers from the Samsung Galaxy S smartphone
## This Script cleans sensor data obtained from waist-mounted smartphone 
## (Samsung Galaxy S II) device for analysis and outputs dataset that 
## includes mean and standard deviation. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. Calculates average for 70 key mean and std dev variables. 
## 6. creates a second, independent tidy data set with the average of each 
##    variable for each activity and each subject.

## Libraries needed: 
install.package("reshape2")
library(reshape2)

## Set working directory
setwd("D:\\Data Science Specialization\\Getting and Cleaning Data\\Course Project")

## If data directory exists, change to that directory.
## Else, create data directory. download and unzip raw data files.
if(!file.exists("./data")) {
        dir.create("./data")
}
## Download and unzip raw data files.
setwd(".\\data")
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./getdata_projectfiles_UCI HAR Dataset.zip", mode = "wb")
unzip("./getdata_projectfiles_UCI HAR Dataset.zip", files = NULL, list = FALSE, overwrite = TRUE,
        junkpaths = FALSE, exdir = ".", unzip = "internal",
        setTimes = FALSE)


## Read raw data files into memory for processing.
train.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train.x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./UCI HAR Dataset/train/y_train.txt")
test.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test.x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./UCI HAR Dataset/test/y_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Merge the test and train subject datasets
subject <- rbind(test.subject, train.subject)
colnames(subject) <- "subject"

# Merge the test and train labels, applying the textual labels
label <- rbind(test.y, train.y)
label <- merge(label, activity.labels, by=1)[,2]

# Merge the test and train main dataset, applying the textual headings
data <- rbind(test.x, train.x)
colnames(data) <- features[, 2]

# Merge all three datasets
dataMerged <- cbind(subject, label, data)

# Create a smaller dataset containing only the mean and std variables
search <- grep("-mean|-std", colnames(dataMerged))
data.mean.std <- dataMerged[,c(1,2,search)]

# Compute the means, grouped by subject/label
melted = melt(data.mean.std, id.var = c("subject", "label"))
means = dcast(melted , subject + label ~ variable, mean)

# Save the resulting dataset
write.table(means, file="./tidy_data.txt")
# Output final dataset
means