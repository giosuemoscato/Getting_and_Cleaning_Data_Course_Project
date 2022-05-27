---
title: "CodeBook"
output: html_document
date: '2022-05-27'
---


## Create one R script called run_analysis.R that does the following:

### Let's merge the training and the test sets to create one data set

#### 1. Create the train dataset

Let's create three variables and bind them in a big dataset

```{r}
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
activity_train <- read.table("UCI HAR Dataset/train/y_train.txt")
measurement_train <- read.table("UCI HAR Dataset/train/X_train.txt")
                
train <- cbind(subject_train, activity_train, measurement_train)
```

-   subject_train = identifies a table in which each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

-   activity_train = identifies a table in which each row identifies the activity performed by the subject. Its range is from 1 to 6.

-   measurement_train = identifies a table in which each column is a different measurement and a total of 561 different measurements

-   train = this dataset is made by the binding of the columns of the three previous tables

#### 2. Create the test dataset

Same as n.1, let's apply the same procedure on the test data sets

```{r}
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

activity_test <- read.table("UCI HAR Dataset/test/y_test.txt")

measurement_test <- read.table("UCI HAR Dataset/test/X_test.txt")


test <- cbind(subject_test, activity_test, measurement_test)

```

#### 3. Let's create the dataset

dataset is created by merging each row of the previous datasets (train and test)

```{r}
dataset <- rbind(train, test)

```

### Appropriately labels the data set with descriptive variable names

#### 1. Let's import the features.txt file and add "Subject" and "Activity" as column names

Here we create a variable "names_of_columns" that we will use to label the columns of the dataset

```{r}
## Let's import the file features.txt containing a title for each measurement
names_of_columns <- read.table("UCI HAR Dataset/features.txt")
## Since the table has 2 columns we subset the columns with the title
names_of_columns <- names_of_columns[,2]
## We add 2 more description (Subject and Activity) to label the first 2 columns of the dataset
names_of_columns <- c("Subject", "Activity", names_of_columns)

```

### 2. Let's modify the syntax to make it more understandable

Here we apply some edit in order to obtain descriptive names more understandable. For example we replace

-   "-" with a "\_"

-   everything that is not a letter with another "\_"

-   remove all the "\_\_" in excess

```{r}
names_of_columns <- gsub("-","_", names_of_columns)

names_of_columns <- gsub("[^A-z]", "_", names_of_columns)

names_of_columns <- gsub("___|__","_", names_of_columns)

names_of_columns <- gsub("_$","", names_of_columns)

```

### 3. Let's set the names of the columns of the dataset

Now, we can add the labels as descriptive columns of the dataset

```{r}
names(dataset) <- names_of_columns

```

### Modify the code for the Activity column of the dataset with descriptive activity names

In the Activity column of the dataset we substitute the number of the activity with a description of the Activity performed by each subject

```{r}
dataset$Activity <- as.character(dataset$Activity)
dataset$Activity <- gsub("1", "WALKING", dataset$Activity)
dataset$Activity <- gsub("2", "WALKING_UPSTAIRS", dataset$Activity)
dataset$Activity <- gsub("3", "WALKING_DOWNSTAIRS", dataset$Activity)
dataset$Activity <- gsub("4", "SITTING", dataset$Activity)
dataset$Activity <- gsub("5", "STANDING", dataset$Activity)
dataset$Activity <- gsub("6", "LAYING", dataset$Activity)

```

At this stage the dataset has been created with the description of the Activities and the right coloumn names.

### Extracts only the measurements on the mean and standard deviation for each measurement.

#### 1. Create an index including all the names of the columns containing mean, Mean, std, Subject or Activity

From the names of the columns of the dataset we want to extract all the variables containing "Mean", "mean" or "std" inside their names. Obviously we want also to extract the Subject and Activity columns from the datset.

```{r}
index <- grep("[Mm]ean|std|Subject|Activity", names(dataset), value = TRUE)

```

#### 2. Extract the columns of interest from the dataset using the previous index

```{r}
dataset <- dataset[,index]

```

### From the previous dataset, create a second, independent tidy data set with the average of each variable for each activity and each subject.

Now we create a second dataset. For this task we use dplyr package that allows to group data according to one or more variables. First we want to group data by Subject and Activity columns; second, we calculate the mean for each grouped measurement using the "summarise_all" function.

```{r}
library(dplyr)
dataset_grouped <- tbl_df(dataset)
dataset_grouped <- group_by(dataset_grouped, Subject, Activity)
dataset_grouped <- summarise_all(dataset_grouped, mean)
                
```

### Create the file txt

Finally, we save the dataset_grouped as a .txt file using the write.table function

```{r}
write.table(dataset_grouped, file = "dataset.txt", row.name=FALSE)

```
