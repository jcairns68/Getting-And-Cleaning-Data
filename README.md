##Creating a tidy data set
### Getting and Cleaning Data: Course Project

---
title: "run_analysis.R"
author: "James Cairns"
date: "Saturday, October 25, 2014"
output: html_document
---
The below piece of code reads in all relevant data files and merges them all together. cbind() and rbind() are used since the data is of the same length/width.

```{r}
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
```

This next section of code removes what I call "false positives" and then subsets to only the "true" means and stdevs. I've identified these as false positives since they are not pure Means and StDevs, but they could have been included. To do this, I identified the false patterns I wanted to remove, identified the columns with the grep function, set them as the negative criteria (i.e. nColCrit) and then subsetted to the remaining columns. Once that was complete, I could use grep to pull out all true positives and subset to those. 

```{r}
#Remove false positives
negCol <- grep("meanFreq|gravityMean|tBodyAccMean|tBodyAccJerkMean|tBodyGyroMean|tBodyGyroJerkMean", names(rFull), ignore.case = TRUE, value = TRUE)
nColCrit <- !(names(rFull) %in% nCol)
nSubData <- rFull[,nColCrit]

#Keep only means and st dev
mColumns <- grep("mean|std|Subject|Label", names(nSubData), ignore.case = TRUE, value = TRUE)
columncriteria <- names(nSubData) %in% mColumns
subData <- nSubData[,columncriteria]
```

After adding activity labels from the activity_labels.txt file, the data set is aggregated by applying mean to all of the columns identified in the above for each Subject and Label by using the aggregate() function. I am sure there is a more elegant way to do this, but when the shoe fits...


```{r}

##Aggregate
TidyData <- aggregate(cbind(tBodyAcc.mean...X,  tBodyAcc.mean...Y, tBodyAcc.mean...Z, tBodyAcc.std...X, tBodyAcc.std...Y, tBodyAcc.std...Z, tGravityAcc.mean...X, tGravityAcc.mean...Y, tGravityAcc.mean...Z, tGravityAcc.std...X, tGravityAcc.std...Y, tGravityAcc.std...Z, tBodyAccJerk.mean...X, tBodyAccJerk.mean...Y, tBodyAccJerk.mean...Z, tBodyAccJerk.std...X, tBodyAccJerk.std...Y, tBodyAccJerk.std...Z, tBodyGyro.mean...X, tBodyGyro.mean...Y, tBodyGyro.mean...Z, tBodyGyro.std...X, tBodyGyro.std...Y, tBodyGyro.std...Z, tBodyGyroJerk.mean...X, tBodyGyroJerk.mean...Y, tBodyGyroJerk.mean...Z, tBodyGyroJerk.std...X, tBodyGyroJerk.std...Y, tBodyGyroJerk.std...Z, tBodyAccMag.mean.., tBodyAccMag.std.., tGravityAccMag.mean.., tGravityAccMag.std.., tBodyAccJerkMag.mean.., tBodyAccJerkMag.std.., tBodyGyroMag.mean.., tBodyGyroMag.std.., tBodyGyroJerkMag.mean.., tBodyGyroJerkMag.std.., fBodyAcc.mean...X, fBodyAcc.mean...Y, fBodyAcc.mean...Z, fBodyAcc.std...X, fBodyAcc.std...Y, fBodyAcc.std...Z, fBodyAccJerk.mean...X, fBodyAccJerk.mean...Y, fBodyAccJerk.mean...Z, fBodyAccJerk.std...X, fBodyAccJerk.std...Y, fBodyAccJerk.std...Z, fBodyGyro.mean...X, fBodyGyro.mean...Y, fBodyGyro.mean...Z, fBodyGyro.std...X, fBodyGyro.std...Y, fBodyGyro.std...Z, fBodyAccMag.mean.., fBodyAccMag.std.., fBodyBodyAccJerkMag.mean.., fBodyBodyAccJerkMag.std.., fBodyBodyGyroMag.mean.., fBodyBodyGyroMag.std.., fBodyBodyGyroJerkMag.mean.., fBodyBodyGyroJerkMag.std..) ~ Subject + Activity, data = tDataWL, mean)

```







