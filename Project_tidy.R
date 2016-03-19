library(dplyr)

file_name <- "get_datasets.zip"

if(!file.exists(file_name)) {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url,file_name)
}

if(!file.exists("UCI HAR Dataset")){
unzip(file_name)
}

## Load Activity List and Features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

## Give proper column names to Activity List and Features
names(activity_labels) <- c("Code","Activity_Name")
names(features) <- c("Code","Feature_names")


## converting Activity and Feature_names to character
activity_labels[,2] <- as.character(activity_labels[,2])
features[,2] <- as.character(features[,2])

##  find postions of features with mean and std and column names
feature_col_ms <- grep("mean()|std()",features[,2])
features_wanted <- features[feature_col_ms,2]

################ Training Data
## Load Training Data

train_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
train_data <- read.table("UCI HAR Dataset/train/x_train.txt")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")


## add columnames 
names(train_data) <- features[,2]
names(train_labels) <- "Activity"
names(train_subject) <- "Subject"

## Filter columns with mean() and std()
train_data_filtered <- train_data[,features_wanted]

## Build training Data
train_combined_data <- cbind(train_subject,train_labels,train_data_filtered)
################ End of Training Data

################ Test Data
## Load Test Data

test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
test_data <- read.table("UCI HAR Dataset/test/x_test.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")


## add columnames 
names(test_data) <- features[,2]
names(test_labels) <- "Activity"
names(test_subject) <- "Subject"

## Filter columns with mean() and std()
test_data_filtered <- test_data[,features_wanted]

## Build training Data
test_combined_data <- cbind(test_subject,test_labels,test_data_filtered)

################ End of Test Data

## Combine Training and Test Data

combined_data <- rbind(train_combined_data,test_combined_data)


## clean Columnnames of combined Data
col_name <- names(combined_data)

for (i in 1:length(col_name))
{
  col_name[i] <- gsub("\\()","",col_name[i])
  col_name[i] <- gsub("-","_",col_name[i])
}

colnames(combined_data) <- col_name

## Group and Summarise data per Subject and Activity

combined_data1 <-  group_by(combined_data,Subject,Activity) %>% summarise_each(funs(mean)) 

## Merge Summarised data with Activity Name
combined_data2 <- merge(combined_data1,activity_labels,by.x="Activity",by.y="Code",all.x = TRUE)
 
## Create Tidy Data with columns re-ordered and sorted by Subject, Activity
tidyData <- select(combined_data2,Subject,Activity,Activity_Name,tBodyAcc_mean_X:fBodyBodyGyroJerkMag_meanFreq) %>% 
  arrange(Subject,Activity)

## Write onto TidyData.txt file
write.table(tidyData,"./tidyData.txt",row.names = FALSE,sep="\t")