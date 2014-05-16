

#
# Helper function for loading the data contained in dir dirname
# expressed by the files subject_dirname.txt, X_dirname.txt and y_dirname.txt.
#
# Return a data frame whose columns are subject, y and x without
# header. i.e the columns are not named
#
load.set <- function(dirname) {

    subject.name <- paste(dirname, "/", "subject_", dirname, ".txt", sep="")
    y.name <- paste(dirname, "/", "y_", dirname, ".txt", sep="")
    x.name <- paste(dirname, "/", "X_", dirname, ".txt", sep="")

    subject.data <- read.table(subject.name)
    y.data <- read.table(y.name)
    x.data <- read.table(x.name)

    data.frame(subject.data, y.data, x.data)
}


#
# Merge train set with test set and then filter all the columns that
# contain mean o std tag. The column names are cleaned of "()" and their
# "-" are replaced by "."
#
# return a clean data frame only containing the means and standard
# deviation and its column name cleaned of "()" and "-" replaced by "."
merge.train.with.test.sets <- function() {

                                        # helpers functions to be used
                                        # as argument of sapply 
  is.mean <- function(x) !is.na(grep("mean", x)[1]) # name contain "mean"
  is.std <- function(x) !is.na(grep("std", x)[1])   # name containg "std"
  remove.pars <- function(x) gsub("\\(\\)", "", x)  # delete "()"
  replace.dash.by.point <- function(x) gsub("-", ".", x)

                                        # features names stringficated
  features <- as.character(read.table("features.txt")[,2]) 

                                        # interesting features (mean and std)
  mean.or.std <- sapply(features, function(x) (is.mean(x) | is.std(x)));

                                        # features names (without "()"
                                        # and with "-" replaced by "."
  feature.names <- sapply(features[mean.or.std], remove.pars, USE.NAMES=FALSE);
  feature.names <- sapply(feature.names, replace.dash.by.point, USE.NAMES=FALSE)

                                        # only pertinent data (subject,
                                        # activity, mean and stds
  data <- rbind(load.set("train"), load.set("test"))[, mean.or.std]
    
  names(data) <- c("subject", "activity", feature.names) # attach column names

  data
}

#
# Compute and returns a data frame with the average values of data (that
# must be obtained by merge.train.with.test.sets()) for each subject and
# each activity
#
# The data frame returned by this function has the column activity as a
# factor with levels WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS,
# SITTING, STANDING and LAYING.  
#
compute.avg.by.subject.and.activity <- function(data) {

  l <- length(names(data))
  num.features <- l -2                    # substract subject and activity

  avg <- c(rep(0.0, num.features))

  df <- data.frame() # data frame to contain the tidy data
  for (subject in 1:30)
      for (activity in 1:6) {
          valid <- data$subject == subject & data$activity == activity
          df <- rbind(df, c(subject, activity, sapply(data[valid, 3:l], mean)))
      }
  
  names(df) <- names(data)
  labels <- read.table("activity_labels.txt")[,2]
  df$activity <- ordered(df$activity, labels=labels) # convert to factor
  df
}

#
# Same as above but a bit slower
#
compute.avg.by.subject.and.activity.1 <- function(data) {

  l <- length(names(data))
  num.features <- l -2                    # substract subject and activity

  avg <- c(rep(0.0, num.features))

  df <- data.frame() # data frame to contain the tidy data
  for (subject in 1:30)
      for (activity in 1:6) {

          valid <- data$subject == subject & data$activity == activity
          for (f in 1:num.features) 
              avg[f] = mean(data[valid, f + 2])

          df <- rbind(df, c(subject, activity, avg))
      }

  names(df) <- names(data)
  labels <- read.table("activity_labels.txt")[,2]
  df$activity <- ordered(df$activity, labels=labels) # convert to factor
  df
}

#
# Same as above but more slower
#
compute.avg.by.subject.and.activity.2 <- function(data) {

  l <- length(names(data))
  num.features <- l -2                    # substract subject and activity
  
  count <- array(rep(0, 30*6), c(30, 6))  # here we count occurrences
  
                                          # and here the variables sums
                                          # initialized to zero
  avg <- array(rep(0.0, 30*6*num.features), c(30, 6, num.features))

                                        # Sum all variables
  for (row in 1:nrow(data)) {
    subject <- data$subject[row]
    activity <- data$activity[row]

    count[subject, activity] = count[subject, activity] + 1

    for (f in 1:num.features) 
      avg[subject, activity, f] = avg[subject, activity, f] + data[row, f + 2]
  }

  df <- data.frame() # data frame to contain the tidy data

                                        # now compute the averages and
                                        # put row in df 
  for (subject in 1:30) {   
      for (activity in 1:6) {
          for (f in 1:num.features) {
              n <- count[subject, activity]
              if (n > 0)  # for avoiding a division by zero if data is corrupted
                  avg[subject, activity, f] <- avg[subject, activity, f]/n
          }
          df <- rbind(df, c(subject, activity, avg[subject, activity,]))
      }
  }
  names(df) <- names(data)
  labels <- read.table("activity_labels.txt")[,2]
  df$activity <- ordered(df$activity, labels=labels) # convert to factor
  df
}

#
# Merge the train and test sets, extract all variables related to means
# and standard deviations, and save the resulting data frame in filename
#
get.and.clean.samsung.data <- function(filename = "samsung-tidy.txt") {

    message("Getting and cleaning samsung data. Please wait\n",
            "The duration of this process depends on your hardware\n\n",
            "Merging test with training sets ans extracting means and std's\n")
    data <- merge.train.with.test.sets()

    message("Done!\n\n",
            "Creating tidy data with average of each variable and activity\n")
    df <- compute.avg.by.subject.and.activity(data)

    message("Done!\n\n",
            "Writing tidy data to ", filename)
    write.table(df, file=filename, quote=F)
        
    message("Done! data was written in ", filename)
}


#
# Compare two data frames obtained from compute.avg.by.subject.and.activity
#
# used for verification purposes
#
# df1 and df2 are data frames obtained from
# compute.avg.by.subject.and.activity() and
# compute.avg.by.subject.and.activity.alternative().
#
# epsilon is the precision
#
compare.avg <- function(df1, df2, epsilon = 10e-6) {

    num.features = length(names(df1)) - 2
    for (subject in 1:30)
        for (activity in levels(df1$activity)) {
            v1 <- df1$subject == subject & df1$activity == activity
            v2 <- df2$subject == subject & df2$activity == activity
            for (feature in 3:num.features) {
                if (abs(df1[v1, feature] - df2[v2, feature]) > epsilon)
                    return (FALSE)
            }
        }
    TRUE
}
