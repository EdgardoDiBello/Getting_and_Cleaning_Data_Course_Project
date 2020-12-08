# run_analysis.R

#0. load package required, dplyr is necessary for the select, group_by, summirase_all comands
library(dplyr)

#1. download and create the data dir

#assign all the routes and names for the file.
#the work directory is assigned the the name of the zip, then the destination directory
#and the data folder direction is assign
rawDataDir <- getwd()
rawDataFileName <- "RawDataProject.zip"
rawDataDestFile <- paste(rawDataDir,"/",rawDataFileName,sep="")
projectData <- paste(getwd(),"/data",sep="")

#check if the file exist
if(!file.exists(rawDataDestFile)){
  rawFileDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(rawFileDataUrl,rawDataDestFile)
}

#check if the directory exist
if(!file.exists(projectData)){
  dir.create(projectData)
  unzip(rawDataDestFile,exdir=projectData)
}

#3. Assigning all the data and adding the col names for each of them

#assigning the activities and features tables 
activities <- read.table(paste0(projectData,"/UCI HAR Dataset/activity_labels.txt"),col.names = c("code","activity"))
features <- read.table(paste0(projectData,"/UCI HAR Dataset/features.txt"),col.names = c("n","functions"))

#assigning the train data
subjecttrain <- read.table(paste0(projectData,"/UCI HAR Dataset/train/subject_train.txt"),col.names = "subject")
xtrain <- read.table(paste0(projectData,"/UCI HAR Dataset/train/x_train.txt"),col.names = features$functions)
ytrain <- read.table(paste0(projectData,"/UCI HAR Dataset/train/y_train.txt"),col.names = "code")

#assigning the test data
subjecttest <- read.table(paste0(projectData,"/UCI HAR Dataset/test/subject_test.txt"),col.names = "subject")
xtest <- read.table(paste0(projectData,"/UCI HAR Dataset/test/x_test.txt"),col.names = features$functions)
ytest <- read.table(paste0(projectData,"/UCI HAR Dataset/test/y_test.txt"),col.names = "code")


#4. merge the training and test data sets
#first the x tables got merge by row, then the y tables, then the subject tables
#finally all the tables got merge by column
x <- rbind(xtrain,xtest)
y <- rbind(ytrain,ytest)
subject <- rbind(subjecttrain,subjecttest)
mergeddata <- cbind(subject,x,y)

#5. extract the mean and standard deviation
#then we get the columns with de mean and standart deviation with de select comand.
tidydata <- select(mergeddata,subject,code,contains("mean"),contains("std"))

#6. use descriptive activities names in the data set
# the second column got the actvities names.
tidydata$code <- activities[tidydata$code,2]

#7. appropriately labels the data with descriptive variable names
#all the variables got a new name by replacing the words with gsub, getting a mor
#descriptive name.
names(tidydata)[2] <- "activity"

names(tidydata) <-gsub("Acc","Accelerometer",names(tidydata))
names(tidydata) <-gsub("Gyro","Gyroscope",names(tidydata))
names(tidydata) <-gsub("Mag","Magnitude",names(tidydata))

names(tidydata) <-gsub("^t","Time",names(tidydata))
names(tidydata) <-gsub("^f","Frequency",names(tidydata))

names(tidydata) <-gsub("BodyBody","Body",names(tidydata))
names(tidydata) <-gsub("tbody","TimeBody",names(tidydata))
names(tidydata) <-gsub("angle","Angle",names(tidydata))
names(tidydata) <-gsub("gravity","Gravity",names(tidydata))

names(tidydata) <-gsub("-mean","Mean",names(tidydata), ignore.case = TRUE)
names(tidydata) <-gsub("-std()","STD",names(tidydata), ignore.case = TRUE)
names(tidydata) <-gsub("-freq()","Frequency",names(tidydata), ignore.case = TRUE)

#8. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
#finally with order the data by subject and activity, and get the mean of all the data. the a .txt file is created with the data.
finaldata <- tidydata %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(finaldata,"finaldata.txt",row.name=FALSE)