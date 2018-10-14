#setwd("D:\\Coursera\\GettingAndCleaningData")
if (!file.exists(".\\data")) {dir.create(".\\data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = ".\\data\\ZipData.zip")
unzip(zipfile = ".\\DATA\\ZipData.zip",exdir = ".\\DATA")
#Dir UCI HAR Dataset created by above command
# set working dir to newly created folder
setwd(".\\DATA\\UCI HAR Dataset")

# read tables in train folder
x_train <- read.table(".\\train\\X_train.txt")
y_train <- read.table(".\\train\\y_train.txt")
sub_train <- read.table(".\\train\\subject_train.txt")
# read tables in test folder
x_test <- read.table(".\\test\\X_test.txt")
y_test <- read.table(".\\test\\y_test.txt")
sub_test <- read.table(".\\test\\subject_test.txt")

features <- read.table(".\\features.txt")
act_lables <- read.table(".\\activity_labels.txt")
# col headings
colnames(x_train) <- features[,2]
colnames(y_train) <- "Act_id"
colnames(sub_train) <- "Sub_id"

colnames(x_test) <- features[,2]
colnames(y_test) <- "Act_id"
colnames(sub_test) <- "Sub_id"

colnames(act_lables) <- c("Act_id","Act_type")
#1. Merges the training and the test sets to create one data set.
train_merge <- cbind(y_train,sub_train,x_train)
test_merge <- cbind(y_test,sub_test,x_test)
Allmerge <-rbind(train_merge,test_merge)
#2.	Extracts only the measurements on the mean and standard deviation for each measurement
colNames = colnames(Allmerge)
meanNstd <- (grepl("Act_id",colNames)|grepl("Sub_id",colNames)|grepl("mean...",colNames)|grepl("std..",colNames))
meanNstd_df <- Allmerge[,meanNstd == TRUE]
#3.	Uses descriptive activity names to name the activities in the data set
activity_df <- merge(meanNstd_df,act_lables,by = "Act_id",all.x = TRUE)
#4.	Appropriately labels the data set with descriptive variable names.
# already done above
#5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Tidy_df <- aggregate(. ~Sub_id + Act_id,activity_df,mean)
Tidy_df <- Tidy_df[order(Tidy_df$Sub_id,Tidy_df$Act_id),]
write.table(Tidy_df,"TidyDataSet.txt",row.names = FALSE)