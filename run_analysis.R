

setwd("/Users/dnilwang/Desktop/UCI HAR Dataset/")

  temp = read.table("activity_labels.txt", sep = "")
  activityLabels = as.character(temp$V2)
  temp = read.table("features.txt", sep = "")
  attributeNames = temp$V2
  
  Xtrain = read.table("train/X_train.txt", sep = "")
  names(Xtrain) = attributeNames
  Ytrain = read.table("train/y_train.txt", sep = "")
  names(Ytrain) = "Activity"
  Ytrain$Activity = as.factor(Ytrain$Activity)
  levels(Ytrain$Activity) = activityLabels

  trainSubjects = read.table("train/subject_train.txt", sep = "")
  names(trainSubjects) = "subject"
  trainSubjects$subject = as.factor(trainSubjects$subject)
  train = cbind(Xtrain, trainSubjects, Ytrain)
  
  Xtest = read.table("test/X_test.txt", sep = "")
  names(Xtest) = attributeNames
  Ytest = read.table("test/y_test.txt", sep = "")
  names(Ytest) = "Activity"
  Ytest$Activity = as.factor(Ytest$Activity)
  levels(Ytest$Activity) = activityLabels
  testSubjects = read.table("test/subject_test.txt", sep = "")
  names(testSubjects) = "subject"
  testSubjects$subject = as.factor(testSubjects$subject)
  test = cbind(Xtest, testSubjects, Ytest)
  
  rm(train, test, temp, Ytrain, Ytest, Xtrain, Xtest, trainSubjects, testSubjects, 
     activityLabels, attributeNames)

all = rbind(train, test)  # combine sets 
all_filter<-all[,grep("mean[(]|std|subject|Activity", colnames(all))]
require(reshape2)
all_melt <- melt(all_filter, id = c("subject", "Activity"))
all_result<-dcast(all_melt, subject + Activity ~ variable, mean)

write.table(all_result, "tidydata.txt", sep="\t")
