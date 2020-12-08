The `run_analysis.R` script performs the data preparation and then followed by the 5 steps required as described in the course project’s definition.

1. Download the dataset
    Dataset downloaded with the comands, and the folder is created

2. Assign each data to variables
    activities <- activity_labels.txt
      List of activities performed when the corresponding measurements were taken and its codes (labels)
    features <- features.txt
      The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.
    subjecttrain <- train/subject_train.txt
      contains train data of 21/30 volunteer subjects being observed
    xtrain <- train/X_train.txt
      contains recorded features train data
    ytrain <- train/y_train.txt
      contains train data of activities’code labels
    subjecttest <- test/subject_test.txt
      contains test data of 9/30 volunteer test subjects being observed
    xtest <- test/X_test.txt
      contains recorded features test data
    ytest <- test/y_test.txt
      contains test data of activities’code labels


3. Merges the training and the test sets to create one data set
    x is created by merging xtrain and xtest using rbind() function
    y is created by merging ytrain and ytest using rbind() function
    subject is created by merging subjecttrain and subjecttest using rbind() function
    mergeddata is created by merging subject, y and x using cbind() function

4. Extracts only the measurements on the mean and standard deviation for each measurement
    tidydata is created by subsetting mergeddata, selecting only columns: subject, code and the measurements on the mean and standard deviation (std) for each measurement

5. Uses descriptive activity names to name the activities in the data set
    code column replaced with corresponding activity taken from second column of the activities variable

6. Appropriately labels the data set with descriptive variable names
    code column in TidyData renamed into activities
    All Acc in column’s name replaced by Accelerometer
    All Gyro in column’s name replaced by Gyroscope
    All BodyBody in column’s name replaced by Body
    All Mag in column’s name replaced by Magnitude
    All start with character f in column’s name replaced by Frequency
    All start with character t in column’s name replaced by Time

7. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
finaldata is created by sumarizing tidydata taking the means of each variable for each activity and each subject, after groupped by subject and activity.
Export finalfata into finaldata.txt file.
