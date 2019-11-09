# This R script contains functions needed for implementing ACWL-C1 and ACWL-C2.
# Code provided in the supplement of: Tao, Y. and Wang, L. (2017), Adaptive contrast weighted learning for multi-stage multi-treatment decision-making. Biom, 73: 145-155. doi:10.1111/biom.12539

# function to estimate propensity score
# input treatment vector A and covariate matrix Xs
M.propen<-function(A,Xs){
  if(ncol(as.matrix(A))!=1) stop("Cannot handle multiple stages of treatments together!")
  if(length(A)!= nrow(as.matrix(Xs))) stop("A and Xs do not match in dimension!")
  if(length(unique(A))<=1) stop("Treament options are insufficient!")
  class.A<-sort(unique(A))
  
  require(nnet)
  s.data<-data.frame(A,Xs)
  # multinomial regression with output suppressed
  model<-capture.output(mlogit<-multinom(A ~., data=s.data))
  s.p<-predict(mlogit,s.data,"probs")
  colnames(s.p)<-paste("A=",class.A,sep="")
  # return a N*K data frame, for each subject (row), the probability of getting each treatment  
  s.p  
}

# function to estimate conditional means
# input Y as a continous outcome of interest
# input H as a matrix of covariates 
Reg.mu<-function(Y,As,H){
  if(nrow(as.matrix(As))!=nrow(as.matrix(H))) stop("Treatment and Covariates do not match in dimension!")
  Ts<-ncol(as.matrix(As)) # number of stages
  N<-nrow(as.matrix(As))
  if(Ts<0 || Ts>3) stop("Only support 1 to 3 stages!") # should be able to extend to the case with more than 4 satges by change the code in this function
  H<-as.matrix(H)
  A1<-as.matrix(As)[,1]
  KT<-length(unique(A1)) # treatment options at last stage
  if(KT<2) stop("No multiple treatment options!")
  RegModel<-lm(Y ~ H*factor(A1))
  # Dimension: number of subjects * number of treatment options
  mus.reg<-matrix(NA,N,KT)
  # rep: assume every one gets this treatment option
  for(k in 1:KT) mus.reg[,k]<-predict(RegModel,newdata=data.frame(H,A1=rep(sort(unique(A1))[k],N)))
  output<-list(mus.reg, RegModel)
  names(output)<-c("mus.reg","RegModel")
  output
}

# function to calculate AIPW adaptive contrasts and working orders
# input outcome Y, treatment vector at this stage A, estimated propensity matrix pis.hat and regression-based conditional means mus.reg
CL.AIPW<-function(Y,A,pis.hat,mus.reg){
  class.A<-sort(unique(A))
  K<-length(class.A)
  N<-length(A)
  if(K<2 | N<2) stop("No multiple treatments or samples!")
  if(ncol(pis.hat)!=K | ncol(mus.reg)!=K | nrow(pis.hat)!=N | nrow(mus.reg)!=N) stop("Treatment, propensity or conditional means do not match!")
  
  #AIPW estimates
  mus.a<-matrix(NA,N,K)
  for(k in 1:K){
    # (4) in the paper
    mus.a[,k]<-(A==class.A[k])*Y/pis.hat[,k]+(1-(A==class.A[k])/pis.hat[,k])*mus.reg[,k]
  }
  # C.a1 and C.a2 are AIPW contrasts; l.a is AIPW working order 
  C.a1<-C.a2<-l.a<-rep(NA,N)
  for(i in 1:N){
    # largest vs. second largest for ith subject
    C.a1[i]<-max(mus.a[i,])-sort(mus.a[i,],decreasing=T)[2]
    # largest vs. smallest for ith subject
    C.a2[i]<-max(mus.a[i,])-min(mus.a[i,])
    l.a[i]<-which(mus.a[i,]==max(mus.a[i,]))
  }
  output<-data.frame(C.a1, C.a2, l.a)
  output
}
