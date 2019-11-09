# d-learn
library(glmnet)
library(dplyr)

set.seed(284)

data <- read.csv("data.csv")
n <- dim(data)[1]
tune <- "lambda.min"
# number of covariates
p <- 5
# Total number of treatment options
K <- 3

X <- as.matrix(data%>%dplyr::select(-A,-Y))
A <- data$A
Y <- data$Y
  
# train 3 models 
A.1.idx<-which(A==1)
A.2.idx<-which(A==2)
A.3.idx<-which(A==3)

A.32 <- A[-A.1.idx]
A.32 <- ifelse (A.32==3,1,-1)
Y.new.32 <- 2*Y[-A.1.idx]*A.32
model.32 <- cv.glmnet(X[-A.1.idx,], Y.new.32, nfolds = 5)

A.31 <- A[-A.2.idx]
A.31 <- ifelse (A.31==3,1,-1)
Y.new.31 <- 2*Y[-A.2.idx]*A.31
model.31 <- cv.glmnet(X[-A.2.idx,], Y.new.31, nfolds = 5)

A.21 <- A[-A.3.idx]
A.21 <- ifelse(A.21==2,1,-1)
Y.new.21 <- 2*Y[-A.3.idx]*A.21
model.21 <- cv.glmnet(X[-A.3.idx,], Y.new.21, nfolds = 5)

pred.32 <- predict(model.32, newx=X, s=tune)
pred.31 <- predict(model.31, newx=X, s=tune)
pred.21 <- predict(model.21, newx=X, s=tune)

f.1 <- (-pred.21-pred.31)
f.2 <- (pred.21-pred.32)
f.3 <- (pred.31+pred.32)

f.all <- cbind(f.1,f.2,f.3)

# optimal ITR by dlearn
estopt.dlearn <- apply(f.all,1, which.max)
