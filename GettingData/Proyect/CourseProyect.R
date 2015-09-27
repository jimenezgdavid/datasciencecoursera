mergeFiles<-function(){
     #NOTE: these are all absolute paths. 
     testDir<-"getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt"
     testLabDir<-"getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt"
     testSubDir<-"getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt"
     trainDir<-"getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt"
     trainLabDir<-"getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt"
     trainSubDir<-"getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt"
     namesDir<-"getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt"
     labKeyDir<-"getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt"
     
     col_names<-read.table(namesDir, stringsAsFactors = FALSE )[,2]
     testLab<-read.table(testLabDir, stringsAsFactors = FALSE)
     trainLab<-read.table(trainLabDir, stringsAsFactors = FALSE)
     labKey<-read.table(labKeyDir, stringsAsFactors = FALSE)
     testSub<-read.table(testSubDir, stringsAsFactors = FALSE)
     trainSub<-read.table(trainSubDir, stringsAsFactors = FALSE)
     
     testLab<-sapply(testLab, hashTable,table=labKey, USE.NAMES=FALSE)
     trainLab<-sapply(trainLab, hashTable,table=labKey, USE.NAMES=FALSE)
     
     is_mean_std<-  sapply(col_names,str.In,str2="std()", USE.NAMES =FALSE ) | sapply(col_names,str.In,str2="mean()", USE.NAMES =FALSE )
     testData<-read.table(testDir,col.names=col_names)[,is_mean_std]
     trainData<-read.table(trainDir,col.names=col_names)[,is_mean_std]
     
     #If one wants to diferentiate between the test and the train data then uncomment the folowwing two lines 
     #testData$type_of_sub<-rep("test",nrow(testData))
     #trainData$type_of_sub<-rep("train",nrow(trainData))
     col_names<-c("subject","activity",col_names[is_mean_std])
     testData<-cbind(testLab, testData)
     testData<-cbind(testSub, testData)
     names(testData)<-col_names
     trainData<-cbind(trainLab, trainData)
     trainData<-cbind(trainSub, trainData)
     names(trainData)<-col_names
     data<-rbind(testData,trainData)
     library(dplyr)
     data<-group_by(data,subject,activity) %>% summarise_each(c("mean"))
     data
     write.table(data,"proyectFinalResultData.txt", row.names=FALSE)
}


str.In<-function(str, str2){
     
     if(class(str) != "character" || class(str2) != "character" ){
          return(FALSE) 
     }
     
     str2Size<-nchar(str2)
     strSize<-nchar(str)
     
     if(str2Size>strSize){
          return(FALSE)
     }
     
     for(i in seq(strSize-str2Size+1)){
          
          if(identical(str2,substr(str, i, i+str2Size-1))){
               return(TRUE)
          }
          
     }
     
     FALSE
}

hashTable<-function(key, table){
     key<-as.numeric(key)
     table[key,2]
}