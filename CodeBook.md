# Transformations applied to the data
There were 5 steps performed to clean the data:

1. First, the training and test sets were merged using the rbind() function to create one data set.

2. In second place, we get the variable names for the previous data set from features.txt and change its column names. Then, only the columns that are related to the mean and standard deviation for each measurement are selected using grep() and the select() function from dplyr. 

3. After that, activities ids for training and test sets are collected and merged with mean_std_measures using cbind(). Then, the names of the activties are taken from activity_labels.txt and each activity id is associated with its name using a for loop.

4. The variable names or columns of mean_std_measures are replaced with more descriptive labels using gsub().

5. Finally, the subject train and test sets are also merged with mean_std_measures using mutate(). Later, the data is grouped by subject and activity name with group_by(). Next, the mean of each column is calculated using summarise_at(). The resulting data frame is written to tidy_data.txt, which is the tidy data uploaded to the assignment.


# Variables
1. X_test has the test set, X_train has the training set and X_train_test is the combination of X_test and X_train.

2. features contains the variable names for X_train_test, mean_std_measures is the data frame that only has the mean and standard deviation related columns filtered in the mean_std variable.

3. The activities ids are located at y_test_labels and y_train_labels. labels represents the combination of the previous two variables. mean_std_measures is overwritten to include labels.

4. The vector that stores the activity names is activity_names. The more descriptive column names is inside the vector new_colnames.

5. The variable that has the subjects sets is called subjects. final_result is mean_std_measures along with the subjects. And, lastly, tidy_data is the data frame that has the mean of each column, which was grouped by subject and activity name.

6. The not mentioned variables were used to store intermediate results in order to enhance code readability.

