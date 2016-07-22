#Set the working directory
setwd("C:\\Users\\Cides Dinero\\Documents\\R")

#Download the file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "Dataset.zip"
download.file(fileUrl,destfile="Dataset.zip")


# Read trainings tables:
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Read testing tables:
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Read feature vector:
features <- read.table("UCI HAR Dataset/features.txt")

# Read activity labels:
activityLabels = read.table("UCI HAR Dataset/activity_labels.txt")

# Column Names
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c("activityId","activityType")

# Merge All Data
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
AllData <- rbind(mrg_train, mrg_test)

# Read Column Names
colNames <- colnames(AllData)

# Mean and Standard Deviation
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

# Subset for AllData
setForMeanAndStd <- AllData[ , mean_and_std == TRUE]

# Descriptive Activity Names
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

# Making Second Tidy Set
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#Write text file
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
