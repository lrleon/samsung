# Script for tiding samsung data about human activity

This repository contains a script for processing the "Human Activity
Recognition database built from the recordings of 30 subjects performing
activities of daily living (ADL) while carrying a waist-mounted
smartphone with embedded inertial sensors."  

More information can be found here

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The file "run_analysis.R" contains a R script that first merges the
train and test sets, then extracts only the measurements on the mean and
standard deviation for each measurement; the other measurements are
discarded.

The labels of data are almost the same that the original database,
except that the "()" are removed and the "-" are replaced by "-". In
this way, the columns have valid names R, susceptible of being
understood by the mechanism of the R repl autocompletion. Finally, a
second tidy data set is built with the average of each variable for each
subject and each activity.

The order of columns of final data is

subject activity averages-of-features-related-to-mean-and-std

Where:
	- subject is an integer between 1 and 30 corresponding to a
	  person
	- activity is a factor of fashion:
	  	   1 WALKING
		   2 WALKING_UPSTAIRS
		   3 WALKING_DOWNSTAIRS
		   4 SITTING
		   5 STANDING
		   6 LAYING
        - averages-of-features-related-to-mean-and-std the averaged
 	  measurements of means ans standard deviations 


The script contain several functions. What you probably want most is the
routine:
	
   get.and.clean.samsung.data <- function(filename = "samsung-tidy.txt")

which performs all described above (merge test an train sets, extract
means and std's and averages them) ans saves the result in filename.


You could be also interested in the function

    merge.train.with.test.sets()

which build the merged test and train sets with the means and std's
extracted.

Eventually, you could also be interested in

    compute.avg.by.subject.and.activity(data)

which returns a data frame corresponding to the averages of data (which
would be obtained from merge.train.with.test.sets())
