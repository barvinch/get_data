# setwd("/project")

#  Read files
# After reding I've checked dimensions of data parts, you can see them commented
features<-read.table("features.txt")
  # dim(features) # [1] 561   2
al <- read.table("activity_labels.txt")
  # dim(al) # [1] 6 2
x_test <- read.table("test/X_test.txt")
  # dim(x_test) # [1] 2947  561
y_test <- read.table("test/y_test.txt")
  # dim(y_test) # [1] 2947    1
s_test <- read.table("test/subject_test.txt")
  # dim(s_test) # [1] 2947    1
x_train <- read.table("train/X_train.txt")
  # dim(x_train) # [1] 7352  561
y_train <- read.table("train/y_train.txt")
  # dim(y_train) # [1] 7352    1
s_train <- read.table("train/subject_train.txt")
  # dim(s_train) # [1] 7352    1

# make unique column names, because some names are duplicated
names(x_train)  <- make.names(features[,2], unique = TRUE) 
names(x_test)   <- make.names(features[,2], unique = TRUE) 

# Activity labels used instead of activity id
test_labels <- al[y_test[,1],2]
train_labels <- al[y_train[,1],2] # tail(y_train,3)
# conver activity names to data frame and giving them meaningfull name "Activity"
tl1 <- as.data.frame(test_labels)
names(tl1) <- "Activity"
tl2 <- as.data.frame(train_labels)
names(tl2) <- "Activity"

## "subject" put as name instead of "V1" set by default
names(s_train) <- "subject"
names(s_test) <- "subject"

# merge data 
ttt <- rbind(x_train, x_test)
  # dim(ttt) # [1] 10299   561
stt <- rbind(s_train, s_test)
  # dim(stt) # [1] 10299     1
ytt <- rbind(tl2, tl1)
  # dim(ytt) # [1] 10299     1

# after making names with make.names() function, 
# we need  variables that contains "mean.." and "std.."
# used to be "mean()" and "std()"
mea <- grep("mean\\.\\.|std\\.\\.", names(ttt)) 
  # dim(ttt[mea]) # [1] 10299    66

# and bind all data we need together
fin <- cbind(ttt[mea],stt,ytt)
  # dim(fin) # [1] 10299    68

# I'll use melt(), so I need reshape2 library
library("reshape2", lib.loc="~/R/win-library/3.1")
# and melt data
Molten <- melt(fin, id.vars = c("subject", "Activity"))
  # dim(Molten) # [1] 679734      4     

# create final tidy dataset
final.data.frame <- dcast(Molten, subject + Activity ~ variable, fun = mean)
  # dim(final.data.frame) # [1] 180  68

# write final data to the file "proj_dat.txt", with tab separation
write.table(final.data.frame, "proj_dat.txt", sep="\t", row.name=FALSE) 
#check if it was written correctly, please set header = TRUE 
# in order to read variable names properly
check_dat <- read.table("proj_dat.txt", sep="\t", header = TRUE) 
