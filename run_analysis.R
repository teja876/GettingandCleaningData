fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
unzip(zipfile = "./data/Dataset.zip", exdir = "./data")
fpath<- file.path("./data","UCI HAR Dataset")
featuretest <- read.table(file.path(fpath , "test" , "X_test.txt"), header = FALSE)
featuretrain <- read.table(file.path(fpath , "train" , "X_train.txt"), header = FALSE)
activitytest<- read.table(file.path(fpath,  "test" ,"y_test.txt"), header = FALSE)
activitytrain<-read.table(file.path(fpath , "train" , "y_train.txt"), header = FALSE)
subjecttest<-read.table(file.path(fpath , "test" , "subject_test.txt"), header = FALSE)
subjecttrain<-read.table(file.path(fpath , "train" , "subject_train.txt"), header = FALSE)
datafeature <- rbind(featuretrain , featuretest)
dataactivity <- rbind(activitytrain , activitytest)
datasubject<- rbind(subjecttrain , subjecttest)
names(dataactivity)<- c("activity")
names(datasubject)<-c("subject")
featurenames<-read.table(file.path(fpath,"features.txt"),header = FALSE)
names(datafeature)<- featurenames$V2
data<- cbind(datafeature , datasubject, dataactivity)
subdatafeaturenames<- featurenames$V2[grep("mean\\(\\)|std\\(\\)", featurenames$V2)]
selectednames<-c(as.character(subdatafeaturenames), "activity", "subject")
data<- subset(data, select = selectednames)
names(data)<-gsub("^t","time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("BodyBody","Body", names(data))
activitylabels<- read.table(file.path(fpath, "activity_labels.txt"), header = FALSE)
data$activity<- factor(data$activity, levels = activitylabels$V1, labels = activitylabels$V2)
data1<- aggregate(.~subject+activity, data, mean)
data1<- data1[order(data1$subject, data1$activity),]
write.table(data1, file = "tidy.txt", row.names = FALSE)






