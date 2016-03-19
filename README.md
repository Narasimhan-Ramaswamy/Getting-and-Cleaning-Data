# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data JHU course.
The script, `Project_tidy.R`, does the following:

1. Downloads and unzips the dataset in the working directory if it doesn't exist 
2. Loads the activity, features, training and test datasets
3. Assigns columnames to loaded datasets (training and test datasets column names are assigned using features)
4. Filters columns relevant to mean and std in test and training data set.  
5. Merges the two datasets and cleanse column names
6. Summarises data relevant to `Subject` and `Activity` and merge it with activity dataset to include Activity Label
7. Creates a tidy dataset with columns re-ordered and sorted by Subject, Activity.
8. write the final output to `tidyData.txt` in working directory.
