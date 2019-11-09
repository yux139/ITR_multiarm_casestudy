# l1-PLS-HGL
library(glinternet)
library(dplyr)

set.seed(284)

data <- read.csv("data.csv")
n <- dim(data)[1]
# number of covariates
p <- 5
# number of treatment options
K <- 3

# A-1 because has to be coded from 0 in glinternet package
X0 <- data%>%dplyr::select(-Y)%>%mutate(A=A-1)

# vector for number of levels needed for glinternet.cv
lv <- c(K,rep(1,p))
model.cv <- glinternet.cv(X = X0,Y = data$Y,numLevels = lv,interactionCandidates = 1, nFolds = 5)

X0.1 <- X0.2 <- X0.3 <- X0

X0.1[,1] <- rep(0,n)
X0.2[,1] <- rep(1,n)
X0.3[,1] <- rep(2,n)

p1<-predict(model.cv,X0.1,type="response",lambdaType = "lambdaHat")
p2<-predict(model.cv,X0.2,type="response",lambdaType = "lambdaHat")
p3<-predict(model.cv,X0.3,type="response",lambdaType = "lambdaHat")

predict.comb <- cbind(p1,p2,p3)

# estimated optimal ITR by l1-pls-hgl
estopt.pls.hgl <- apply(predict.comb,1,which.max)
