# Script for tidying samsung data about human activity

## Introduction

This repository contains a script for processing the "Human Activity
Recognition database built from the recordings of 30 subjects performing
activities of daily living (ADL) while carrying a waist-mounted
smartphone with embedded inertial sensors."  

More information can be found here

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The file "run_analysis.R" contains a R script that first merges the
train and test sets, then extracts only the measurements on the mean and
standard deviation for each measurement; the other measurements are
discarded. The labels of data are almost the same that the original database,
except that the "()" are removed and the "-" are replaced by ".". In
this way, the columns conform R valid names, susceptible of being
understood by the autocompletion mechanism of the R repl. Finally, a
second tidy data set is built with the average of each variable for each
subject and each activity.

The order of columns of final data is

    subject activity averages-of-features-related-to-mean-and-std

Where: 

* subject is an integer between 1 and 30 corresponding to a person
* activity is a factor between the following levels:
  - 1 WALKING
  - 2 WALKING_UPSTAIRS
  - 3 WALKING_DOWNSTAIRS
  - 4 SITTING
  - 5 STANDING
  - 6 LAYING
* averages-of-features-related-to-mean-and-std the averaged measurements of means and standard deviations 

## Files in this repo

This repo contains the following files:

* README.md: this file that you are reading
* codeBook.md: contains description of variables and transformations
   done by the functions of run_analysis.R
* run_analysis.R: R script with functions for processing the samsung data

## Instructions for building the tidy data set

* unzip the samsung data in the directory of your preference
* cd to UCI HAR Dataset directory.

From this point there are two possible paths

1-. Run the script from shell

    Rscript run_analysis.R

2-. Or 
* Open a R repl in the above directory
* On the R repl execute
  - source("run_analysis.R")
  - compute.avg.by.subject.and.activity()
  After completion, the working directory will contain the file
  "samsung-tidy.txt", This file can be loaded as a R data frame with
   read.table("samsung-tidy.txt")

The advantage of this option is that you could execute other
functions. By example, you could be interested in getting the data
without averaging. In this case, execute:

	df <- merge.train.with.test.sets()

in order to get in df variable a data frame of the variables without
averaging. 


The samsung data is at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Functions in the file run_analysis.R

In order to the functions in run_analysis.R work adequately is very very
important that **your working directory be the root of your samsung
data**. Please be very careful with this because the scripts do not
validate this condition.

See codeBook.md file in order to precise details about the columns
naming and the data finally extracted. 

### Turnkey solution

What you probably want most is the routine:
	
	get.and.clean.samsung.data(filename = "samsung-tidy.txt")

which performs all described above (merge test an train sets, extract
means and std's and averages them) ans saves the result in filename.


### Data without averaging

You could be also interested in the function

    merge.train.with.test.sets()

which build the merged test and train sets with the means and std's
extracted.

### Data averaged in a data frame

Eventually, you could also be interested in

    compute.avg.by.subject.and.activity(data)

which returns a data frame corresponding to the averages of data (which
would be obtained from merge.train.with.test.sets())
