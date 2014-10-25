## Download and Unzip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./GalaxyData.zip")
zFile <- "./GalaxyData.zip"
unzip(zFile)

##Read in all relevant files and create single raw data set

features <- read.table("./UCI HAR Dataset/features.txt")

rawTest <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features[,2])
rSubTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
rLabTest <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "Label")
rTestFull <- cbind(rawTest, rSubTest, rLabTest)

rawTrain <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features[,2])
rSubTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
rLabTrain <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "Label")
rTrainFull <- cbind(rawTrain, rSubTrain, rLabTrain)

rFull <- rbind(rTestFull, rTrainFull)

##Subset the data
#Remove false positives
negCol <- grep("meanFreq|gravityMean|tBodyAccMean|tBodyAccJerkMean|tBodyGyroMean|tBodyGyroJerkMean", names(rFull), ignore.case = TRUE, value = TRUE)
nColCrit <- !(names(rFull) %in% nCol)
nSubData <- rFull[,nColCrit]

#Keep only means and st dev
mColumns <- grep("mean|std|Subject|Label", names(nSubData), ignore.case = TRUE, value = TRUE)
columncriteria <- names(nSubData) %in% mColumns
subData <- nSubData[,columncriteria]

#Add activity labels
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("Label", "Activity"))
tDataWL <- merge(x = subData, y = activitylabels, by = "Label")


##Aggregate
TidyData <- aggregate(cbind(tBodyAcc.mean...X,  tBodyAcc.mean...Y, tBodyAcc.mean...Z, tBodyAcc.std...X, tBodyAcc.std...Y, tBodyAcc.std...Z, tGravityAcc.mean...X, tGravityAcc.mean...Y, tGravityAcc.mean...Z, tGravityAcc.std...X, tGravityAcc.std...Y, tGravityAcc.std...Z, tBodyAccJerk.mean...X, tBodyAccJerk.mean...Y, tBodyAccJerk.mean...Z, tBodyAccJerk.std...X, tBodyAccJerk.std...Y, tBodyAccJerk.std...Z, tBodyGyro.mean...X, tBodyGyro.mean...Y, tBodyGyro.mean...Z, tBodyGyro.std...X, tBodyGyro.std...Y, tBodyGyro.std...Z, tBodyGyroJerk.mean...X, tBodyGyroJerk.mean...Y, tBodyGyroJerk.mean...Z, tBodyGyroJerk.std...X, tBodyGyroJerk.std...Y, tBodyGyroJerk.std...Z, tBodyAccMag.mean.., tBodyAccMag.std.., tGravityAccMag.mean.., tGravityAccMag.std.., tBodyAccJerkMag.mean.., tBodyAccJerkMag.std.., tBodyGyroMag.mean.., tBodyGyroMag.std.., tBodyGyroJerkMag.mean.., tBodyGyroJerkMag.std.., fBodyAcc.mean...X, fBodyAcc.mean...Y, fBodyAcc.mean...Z, fBodyAcc.std...X, fBodyAcc.std...Y, fBodyAcc.std...Z, fBodyAccJerk.mean...X, fBodyAccJerk.mean...Y, fBodyAccJerk.mean...Z, fBodyAccJerk.std...X, fBodyAccJerk.std...Y, fBodyAccJerk.std...Z, fBodyGyro.mean...X, fBodyGyro.mean...Y, fBodyGyro.mean...Z, fBodyGyro.std...X, fBodyGyro.std...Y, fBodyGyro.std...Z, fBodyAccMag.mean.., fBodyAccMag.std.., fBodyBodyAccJerkMag.mean.., fBodyBodyAccJerkMag.std.., fBodyBodyGyroMag.mean.., fBodyBodyGyroMag.std.., fBodyBodyGyroJerkMag.mean.., fBodyBodyGyroJerkMag.std..) ~ Subject + Activity, data = tDataWL, mean)

##Output Tidy Data set
write.table(TidyData, file = './TidyDataSet.csv', sep = ',', row.names = FALSE)

