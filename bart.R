library(BART)
library(dplyr)

set.seed(284)

data <- read.csv("data.csv")
n <- dim(data)[1]
# number of covariates
p <- 5
# number of treatment options
K <- 3

dat <- as.matrix(data%>%dplyr::select(-Y))
X <- as.matrix(data%>%dplyr::select(-A,-Y))
A <- data$A
Y <- data$Y

# data for prediction  
test <- data.matrix(rbind(cbind(rep(1,n),X),cbind(rep(2,n),X),cbind(rep(3,n),X)))
colnames(test) <- colnames(dat)

# fit BART  
post <- wbart(dat, Y, test)
 
itr <- cbind(post$yhat.test.mean[(1:n)], post$yhat.test.mean[n+(1:n)],post$yhat.test.mean[2*n+(1:n)])
  
# find the BART ITR for each individual
itr.pick <- rep(NA,n)
for(j in 1:n) itr.pick[j] <- which(itr[j, ]==max(itr[j, ]))

# estimated optimal ITR by BART  
estopt.bart <- itr.pick
  