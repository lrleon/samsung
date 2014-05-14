
library(RUnit)

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
# Merge a raw data frame with 
merge.train.with.test.sets <- function() {

                                        # helpers functions to be used
                                        # as argument of sapply 
  is.mean <- function(x) !is.na(grep("mean", x)[1])
  is.std <- function(x) !is.na(grep("std", x)[1])
  remove.pars <- function(x) gsub("\\(\\)", "", x)
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
                                        # y, mean and stds
  data <- rbind(load.set("train"), load.set("test"))[, mean.or.std]
    
  names(data) <- c("subject", "activity", feature.names) # attach column names

  data
}

compute.avg.by.subject.and.activity <- function(data) {

  l <- length(names(data))
  num.features <- l -2                    # substract subject and y
  count <- array(rep(0, 30*6), c(30, 6))  # here we count occurrences
                                          # and here the variables totals
                                          # initialized to zero
  avg <- array(rep(0.0, 30*6*num.features), c(30, 6, num.features))

  nrow <- nrow(data)
  for (row in 1:nrow) {
    subject <- data$subject[row]
    activity <- data$activity[row]

    stopifnot(subject > 0 & subject <= 30)
    stopifnot(activity > 0 & activity <= 6)
    
    count[subject, activity] = count[subject, activity] + 1

    avg[subject, activity, subject] <- subject
    avg[subject, activity, activity] <- activity

    for (f in 1:num.features)       
      avg[subject, activity, f] = avg[subject, activity, f] + data[row, f + 2]
  }

  for (subject in 1:30) {
      for (activity in 1:6) {
          for (f in 1:num.features) {
              n <- count[subject, activity]
              if (n > 0)
                  avg[subject, activity, f] <- avg[subject, activity, f] / n
          }
      }
  }

  avg
}


get.and.clean.samsung.data <- function() {

  print("Getting and cleaning samsung data. Please wait")
  print("The duration of this process depends on your hardware")
  write.table(merge.train.with.test.sets(), file="data.txt",quote=F)
  print("Done! data was written in data.txt file.")
}
