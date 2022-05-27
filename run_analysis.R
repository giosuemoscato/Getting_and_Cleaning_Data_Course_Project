#THE CODE CAN BE RUN AS LONG AS THE SAMSUNG DATA IS IN YOUR WORKING DIRECTORY!!!
#PLEASE CHECK THAT THE CORRECT DATA IS IN YOUR WORKING DIRECTORY!!!


###create one R script called run_analysis.R that does the following: 


        ## Let's merge the training and the test sets to create one data set.
                
                #1. create the train dataset
                subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
                activity_train <- read.table("UCI HAR Dataset/train/y_train.txt")
                measurement_train <- read.table("UCI HAR Dataset/train/X_train.txt")
                
                train <- cbind(subject_train, activity_train, measurement_train)
                
                #2. create the test dataset
                subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
                activity_test <- read.table("UCI HAR Dataset/test/y_test.txt")
                measurement_test <- read.table("UCI HAR Dataset/test/X_test.txt")
                
                test <- cbind(subject_test, activity_test, measurement_test)
                
                #3. let's create the dataset
                dataset <- rbind(train, test)
                
                
        ## Appropriately labels the data set with descriptive variable names. 
                
                #1. Let's import the features.txt file and add "Subject" and "Activity" as column names
                names_of_columns <- read.table("UCI HAR Dataset/features.txt")
                names_of_columns <- names_of_columns[,2]
                names_of_columns <- c("Subject", "Activity", names_of_columns)
                
                #2. Let's modify the syntax to make it more understandable
                names_of_columns <- gsub("-","_", names_of_columns)
                names_of_columns <- gsub("[^A-z]", "_", names_of_columns)
                names_of_columns <- gsub("___|__","_", names_of_columns)
                names_of_columns <- gsub("_$","", names_of_columns)
                
                #3. Let's set the names of the columns of the dataset
                names(dataset) <- names_of_columns
                
                
        ## Modify the code for the Activity column of the dataset with descriptive activity names
                dataset$Activity <- as.character(dataset$Activity)
                dataset$Activity <- gsub("1", "WALKING", dataset$Activity)
                dataset$Activity <- gsub("2", "WALKING_UPSTAIRS", dataset$Activity)
                dataset$Activity <- gsub("3", "WALKING_DOWNSTAIRS", dataset$Activity)
                dataset$Activity <- gsub("4", "SITTING", dataset$Activity)
                dataset$Activity <- gsub("5", "STANDING", dataset$Activity)
                dataset$Activity <- gsub("6", "LAYING", dataset$Activity)
                
        ## Extracts only the measurements on the mean and standard deviation for each measurement. 
                
                #1.create an index including all the names of the columns containing mean, Mean, std, Subject or Activity
                index <- grep("[Mm]ean|std|Subject|Activity", names(dataset), value = TRUE)
                
                #2.extract the columns of interest from the dataset using the previous index
                dataset <- dataset[,index]
                
                
        ##From the previous dataset, create a second, independent tidy data set with the 
        ##average of each variable for each activity and each subject.
                library(dplyr)
                dataset_grouped <- tbl_df(dataset)
                dataset_grouped <- group_by(dataset_grouped, Subject, Activity)
                dataset_grouped <- summarise_all(dataset_grouped, mean)
                
        ## create the file txt
                write.table(dataset_grouped, file = "dataset.txt", row.name=FALSE)
                
                
                
                
                
                
                
                
                
                
                
                