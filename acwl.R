# This R script is adapted from the code provided in the supplement of: 
# Tao, Y. and Wang, L. (2017), Adaptive contrast weighted learning for multi-stage multi-treatment decision-making. Biom, 73: 145-155. doi:10.1111/biom.12539
source("functions for simulations.R")

library(rpart)
library(MASS)
library(dplyr)

set.seed(284)

data <- read.csv("data.csv")
n <- dim(data)[1]

X0 <- data%>%dplyr::select(x1,x2,x3,x4,x5)
A <- data$A
Y <- data$Y

pis.hat<-M.propen(A=A,Xs=rep(1,n))
REG<-Reg.mu(Y=Y,As=A,H=X0)
mus.reg<-REG$mus.reg
  
# AIPWE adaptive contrasts and working orders
CLs.a<-CL.AIPW(Y,A,pis.hat,mus.reg)
  
# AIPWE contrasts
C.a1<-CLs.a$C.a1
C.a2<-CLs.a$C.a2
# AIPWE working order 
l.a<-CLs.a$l.a

dat_ACWL<-data.frame(cbind(l.a,data))
    
# rpart fit model
fit.a1<-rpart(l.a ~ x1+x2+x3+x4+x5, data=dat_ACWL, weights=C.a1, method="class")
fit.a2<-rpart(l.a ~ x1+x2+x3+x4+x5, data=dat_ACWL, weights=C.a2, method="class")

# estimated optimal ITR
estopt.acwl1<-as.numeric(predict(fit.a1,dat_ACWL,type="class"))
estopt.acwl2<-as.numeric(predict(fit.a2,dat_ACWL,type="class"))
