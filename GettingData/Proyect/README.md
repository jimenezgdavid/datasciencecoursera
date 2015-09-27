Calculations
==========

Datasets test and train where modified to have the variable names. 

Using the function str.In inside sapply the variables without the strings "mean()" or "std()" where removed.

Activity vector was modified in order to have names instead of ints using the hashtable function and the sapply.
 
Subject and activity variables were added to each DataSet using cbind().

Datasets test and train where added together using rbind.

Using the package dplyr a summary was made to have the mean() for each activity by subject.