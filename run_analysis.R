

##  loading the required package
library(dplyr)

##  downloading the dataset file and unzip it
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
File <- "UCI HAR Dataset.zip"
if (!file.exists(File)) {
        download.file(Url, File, mode = "wb")}
Path <- "UCI HAR Dataset"
        if (!file.exists(Path)) {
                unzip(File)}

##  Reading in the datasets into R and assigning them to variables
train_subject <- read.table(file.path(Path, "train", "subject_train.txt"),col.names = "subject")
train_x <- read.table(file.path(Path, "train", "X_train.txt"),col.names = features$functions)
train_y <- trainingActivity <- read.table(file.path(Path, "train", "y_train.txt"),col.names = "code")

test_Subject <- read.table(file.path(Path, "test", "subject_test.txt"),col.names = "subject")
test_x <- read.table(file.path(Path, "test", "X_test.txt"),col.names = features$functions)
test_y <- read.table(file.path(Path, "test", "y_test.txt"),col.names = "code")
features <- read.table(file.path(Path, "features.txt"), col.names = c("n","functions"))
activities <- read.table(file.path(Path, "activity_labels.txt"),col.names = c("code", "activity"))

## 1 Merge the x sets and y sets to generate a total data set
x_set <- rbind(train_x,test_x)
y_set <- rbind(train_y, test_y)
subject_set <- rbind(test_Subject, train_subject)
Data_total <- cbind(subject_set, y_set,x_set)

## 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
tidy <- select(Data_total, subject, code, contains("mean"), contains("std"))

## 3 Uses descriptive activity names to name the activities in the data set.
tidy$code <- activities[tidy$code, 2]

## 4  Appropriately labels the data set with descriptive variable names.
names(tidy)[2] = "activity"
names(tidy)<-gsub("Acc", "Accelerometer", names(tidy))
names(tidy)<-gsub("Gyro", "Gyroscope", names(tidy))
names(tidy)<-gsub("BodyBody", "Body", names(tidy))
names(tidy)<-gsub("Mag", "Magnitude", names(tidy))
names(tidy)<-gsub("^t", "TimeDomain", names(tidy))
names(tidy)<-gsub("^f", "FrequencyDomain", names(tidy))
names(tidy)<-gsub("tBody", "TimeBody", names(tidy))
names(tidy)<-gsub("-mean()", "Mean", names(tidy), ignore.case = TRUE)
names(tidy)<-gsub("-std()", "StandardDeviation", names(tidy), ignore.case = TRUE)
names(tidy)<-gsub("-freq()", "Frequency", names(tidy), ignore.case = TRUE)

##  From the data set in step 4, creates a second, independent tidy data set 
##   with the average of each variable for each activity and each subject.
Dataset<- tidy %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
