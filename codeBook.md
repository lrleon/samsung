# CodeBook for data processed by functions contained in run_analysis.R

From

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones: 

"Human Activity Recognition database built from the recordings of 30
subjects performing activities of daily living (ADL) while carrying a
waist-mounted smartphone with embedded inertial sensors."

## About variable names

The original samsung data containg 561 measurements, already
pre-processed, that were obtained from two transducers: accelerometer
and gyroscope. Both measurements were recorded in time and frequency
domain variables. The original data have different types of measures for
those variables; by example, the mean, the standard deviation, the
median absolute deviation, etc. Read the features_info.txt file in order
to get additional information. **Our script builds a data frame
consisting of the average of all measurements that are means or standard
deviation**. The other measures (max, min, energy, etc) are discarded.

The measurement were taken for thirty subjects and the following activities:
* 1 WALKING
* 2 WALKING_UPSTAIRS
* 3 WALKING_DOWNSTAIRS
* 4 SITTING
* 5 STANDING
* 6 LAYING

The general structure of variable naming is 

    [t|f]Name[Acc|Gyro].[mean|std].[XYZ]

* [t|f] is a prefix indicating the domain of variable; **t** for time and
  **f** for frequency
* Name is the name of variable; it always starts with upper case.
* [Acc|Gyro] is the transducer giving the variable. Acc is for the
  accelerometer and Gyro is for the gyroscope
* [mean|std] is the measurement type: mean and std for standard deviation
* In those cases where apply the dimensions, the suffix .X, .Y or .Z is
  added.

So, by example, the variable tBodyAcc.mean.Z indicates the mean of z
coordinate for the body measure taken by the accelerometer. 

According to the file features_info.txt, the variables could be classified 
* tBodyAcc.XYZ
* tGravityAcc.XYZ
* tBodyAccJerk.XYZ
* tBodyGyro.XYZ
* tBodyGyroJerk.XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc.XYZ
* fBodyAccJerk.XYZ
* fBodyGyro.XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

Note that in the resulting tidy data these variables have the word
".mean" or ".std" as part of your names; they are omitted for the sake
of "line's economy". **Do not forget that all above variables represent
averages**.

The column order in the final tidy data is:

    subject activity averages-of-features-related-to-mean-and-std


## Basic instructions for building a initial tidy data set

From the directory where you wish work execute

     unzip UCI\ HAR\ Dataset.zip

cd to the root data directory

	cd UCI\ HAR\ Dataset

### Run script in batch mode

    Rscript run_analysis.R

After a few seconds the tidy data set will be located at
"samsung-tidy.txt".

### Run script from R repl

Open a R repl

       R

from the R repl execute

     get.and.clean.samsung.data()

 You can load the data by executing

		    data <- read.table("samsung-tidy.txt")


## About the functions in the script run_analysis.R

The original samsung database is divided is two sets located at the
train and test directories respectively. The functions of this file are
intended to process all this data and to extract the mean and standard
deviations of variables already described.

The functions should be executed from a R repl and they assume that the
working directory is the root of samsung database (named "UCI HAR Dataset")

The most interesting functions are:

    merge.train.with.test.sets() 

which returns a data frame with the two sets merged and the variables
extracted (the other are discarded). In this data frame the activity is
an integer.   

     compute.avg.by.subject.and.activity(data) 

which receives a data frame obtained by the above function and builds and
return a new data frame consisting of averages of feature variables of
data. This data frame has factor for the activity. 

  	get.and.clean.samsung.data(filename)

which invokes the above functions (in order) and save the resulting data frame
in filename. If filename is not specified, then the file name will be
"samsung-tidy.txt". This file can be loaded as a R data frame calling  

  	  read.table("samsung-tidy.txt") 


The final order of a row is: subject, activity and variables in the same
order presented in the previous section. The row length in columns is 81
in both data sets.


