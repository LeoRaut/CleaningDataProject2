

# First make sure that the data set is there. If you want to avoid this part, make sure there is a
# folder called Get_Clean_Cw and inside it the unzipped contents of the dataset

if(!file.exists("./Get_Clean_CW")){dir.create("./Get_Clean_CW")}

if(!file.exists("./Get_Clean_CW/UCI HAR Dataset/train/X_train.txt")){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,destfile="./Get_Clean_CW/Dataset.zip")
  
  unzip(zipfile="./Get_Clean_CW/Dataset.zip",exdir="./Get_Clean_CW")
}


# Get the training set data loaded in:
x_train <- read.table("./Get_Clean_CW/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./Get_Clean_CW/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./Get_Clean_CW/UCI HAR Dataset/train/subject_train.txt")


# Get the test set data loaded in:
x_test <- read.table("./Get_Clean_CW/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./Get_Clean_CW/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./Get_Clean_CW/UCI HAR Dataset/test/subject_test.txt")


# Reading feature vector:
feat <- read.table('./Get_Clean_CW/UCI HAR Dataset/features.txt')

# Reading activity labels:
acLabels = read.table('./Get_Clean_CW/UCI HAR Dataset/activity_labels.txt')


# Set the column names to make merging easier. 
colnames(x_train) <- feat[,2] 
colnames(y_train) <-"activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- feat[,2] 
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(acLabels) <- c('activityID','activityType')


# merge the datasets together like requested
merged_training_data <- cbind(y_train, subject_train, x_train)
merged_test_data <- cbind(y_test, subject_test, x_test)

FullDataSet <- rbind(merged_training_data, merged_test_data)

# get the names of each column in the data set to make the subset easier.
colNames <- colnames(FullDataSet)


# logical vector to only grab columns that have activityID, subjectID, mean, or std in them
mean_and_std <- (grepl("activityID" , colNames) |  grepl("subjectID" , colNames) | 
                grepl("mean.." , colNames) | grepl("std.." , colNames) )

# using above vector create a subset of the data only grabbing appropriate columns
MeanAndStd <- FullDataSet[ , mean_and_std == TRUE]

#Column names added
ActivityNames <- merge(MeanAndStd, acLabels,by='activityID',all.x=TRUE)


#Finally, create the second data set and output it into a text file.
TidyDataSet <- aggregate(. ~subjectID + activityID, ActivityNames, mean)
TidyDataSet <- TidyDataSet[order(TidyDataSet$subjectID, TidyDataSet$activityID),]
write.table(TidyDataSet, "TidyDataSet.txt", row.name=FALSE)
