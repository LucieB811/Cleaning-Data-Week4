library(reshape2)

# Download and unzip the dataset:
filename <- "getdata_dataset.zip"

if (!file.exists (filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file (fileURL, filename, method="curl")
}  

if (!file.exists ("UCI HAR Dataset")) { 
    unzip (filename) 
}

# Part 1 
# Merges the training and the test sets to create one data set
# read train data
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
xTrain <- read.table ("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table ("UCI HAR Dataset/train/Y_train.txt")

# read test data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
xTest <- read.table ("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table ("UCI HAR Dataset/test/Y_test.txt")

# combine test and train - train data first 
subjects <- rbind (subjectTrain, subjectTest)
xData <- rbind (xTrain, xTest)
yData <- rbind (yTrain, yTest)


# Part 2 
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# find mean and std columns
features <- read.table ("UCI HAR Dataset/features.txt")
featureNames <- as.character (features [, 2])

featureInd <- grepl(".*[mM]ean.*|.*[sS]td.*", featureNames)
selectedxData <- xData [,featureInd]
    

# Part 3
# Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table ("UCI HAR Dataset/activity_labels.txt")
activityNames <- activityLabels [, 2]
renamedActivities <- factor (yData [,1], levels = activityLabels [, 1], labels = activityNames)


# Finish binding columns subject x and y train 
allData <- cbind (subjects, renamedActivities, selectedxData)


# Part 4
# Appropriately labels the data set with descriptive variable names

selectedFeatureNames <- featureNames [featureInd]
# remove ()
selectedFeatureNames <- gsub ("[()]", "", selectedFeatureNames)
# rename the columns
colnames(allData) <- c ("subject", "activity", selectedFeatureNames)


# Part 5
# From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.
meltData <- melt (allData, id = c ("subject", "activity"))
tidyData <- dcast (meltData, subject + activity ~ variable, mean)

finalData <- write.table (tidyData, "tidyData.txt", row.names = FALSE, quote = FALSE)
