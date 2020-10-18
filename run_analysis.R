library(dplyr)
setwd("C:/Users/julia/OneDrive/Escritorio/Rprogramming/CleaningDataProject/UCIHARDataset")

# 1. Merge training and test sets to create one data set.
X_test <- read.table("./test/X_test.txt", header = FALSE, sep = "")
X_train <- read.table("./train/X_train.txt",header = FALSE, sep = "")

X_train_test <- rbind(X_test, X_train)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Get colnames from features.txt and name the merged data
features <- read.table("features.txt",header = FALSE, sep=" ")
colnames(X_train_test) <- features$V2

# Filter variables that contain mean and std (which are mean() and std() according to features_info.txt)
mean_std <- grep("(mean\\(\\)|std\\(\\))", colnames(X_train_test), ignore.case = TRUE, value=TRUE)

mean_std_measures <- X_train_test %>%
    select(all_of(mean_std))

# 3. Uses descriptive activity names to name the activities in the data set
# Bring activity numbers from y_train.txt and y_test.txt
y_test_labels <- read.table("./test/y_test.txt")
y_train_labels <- read.table("./train/y_train.txt",header = FALSE, sep = "")

# Merge y_test_labels with y_train_labels and then with mean_std_measures
labels <- rbind(y_test_labels, y_train_labels)
colnames(labels) <- c("activity_id")

mean_std_measures <- cbind(mean_std_measures, labels)

# Get the actual activity names from activity_labels.txt
activities <- read.table("activity_labels.txt", sep=" ", col.names = c("activity_id", "activity_name"))

# Join data set by activity number/id
activity_names <- character()

for(num in 1:nrow(mean_std_measures)){
    activity_names[num] <- subset(activities, activity_id == mean_std_measures$activity_id[num])$activity_name
}

mean_std_measures$activity_name <- activity_names

# 4. Appropriately labels the data set with descriptive variable names.
# Rename resulting dataset from step 3 (mean_std_measures) using features_info
new_colnames <- gsub("\\(\\)", "", colnames(mean_std_measures))
new_colnames <- gsub("-", "_", new_colnames)
new_colnames <- gsub("^f", "Frequency", new_colnames)
new_colnames <- gsub("^t", "Time", new_colnames)
new_colnames <- gsub("gyro", "Gyroscope", new_colnames,ignore.case = TRUE)
new_colnames <- gsub("acc", "Acceleration", new_colnames,ignore.case = TRUE)
new_colnames <- gsub("mag", "Magnitude", new_colnames,ignore.case = TRUE)
new_colnames <- gsub("BodyBody", "Body", new_colnames)

colnames(mean_std_measures) <- new_colnames

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of
# each variable for each activity and each subject.
# Calculate average by activity and subject
subject_test <- read.table("./test/subject_test.txt")
subject_train <- read.table("./train/subject_train.txt")
subjects <- rbind(subject_test,subject_train)

final_result <- mean_std_measures %>%
    mutate(subject=subjects$V1)

tidy_data <- final_result %>% group_by(subject, activity_name) %>%
    summarise_at(vars(-activity_id), mean,na.rm=TRUE)

# Write tidy_data into a txt file
write.table(tidy_data, file="tidy_data.txt", sep='\t', row.names=FALSE)

