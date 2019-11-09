# l1-PLS-GL
library(oem)
library(dplyr)

set.seed(284)

data <- read.csv("data.csv")
n <- dim(data)[1]
X0 <- data%>%dplyr::select(-Y)
X0[,1] <- factor(X0[,1])
covnames <- paste(colnames(X0)[-1],collapse = "+")
fmla <- as.formula(paste("~",covnames,"+A+(",covnames,")*A"))
base <- model.matrix(fmla,data=X0)[,-1]
# number of covariates
p <- 5
# number of treatment options
K <- 3
# group vector needed in cv.oem
grp <- c(1:p,rep(p+1,K-1),rep((p+2):(2*p+1),each=K-1))
model.cv <- cv.oem(base,data$Y,penalty = "grp.lasso", groups=grp, nfolds=5)

X0.1 <- X0.2 <- X0.3 <- X0

X0.1[,1] <- factor(rep(1,n),levels=c(1,2,3))
X0.2[,1] <- factor(rep(2,n),levels=c(1,2,3))
X0.3[,1] <- factor(rep(3,n),levels=c(1,2,3))

base.1 <- model.matrix(fmla,data=X0.1)[,-1]
base.2 <- model.matrix(fmla,data=X0.2)[,-1]
base.3 <- model.matrix(fmla,data=X0.3)[,-1]

p1<-predict(model.cv, newx=base.1, which.model = "best.model", s="lambda.min")
p2<-predict(model.cv, newx=base.2, which.model = "best.model", s="lambda.min")
p3<-predict(model.cv, newx=base.3, which.model = "best.model", s="lambda.min")

predict.comb <- cbind(p1,p2,p3)

# estimated optimal ITR by l1-pls-gl
estopt.pls.gl <- apply(predict.comb,1,which.max)
