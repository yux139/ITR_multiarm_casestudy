# ITR_multiarm_casestudy
This folder contains the code for implementing five methods that can be used to estimate the optimal individualised treatment rules (ITR) in large-scale multi-arm trials. Please refer to the manuscript entitled "Optimal individualized decision rules from a multi-arm trial: personalizing inter-donation intervals among blood donors in the UK" for a review of methods.

- data.csv: <br />
  an example simulated dataset with n=20000, p=5 baseline covariates, and K=3 treatment options 
- functions for simulations.R: <br />
  this R script contains functions needed for implementing ACWL (code provided by the author in [1]).
- acwl.R: <br />
  this R script contains the code for implementing ACWL (adapted from the code provided in [1]).
- bart.R: <br />
  this R script contains the code for implementing the BART ITR estimation method [2].
- dlearn.R: <br /> 
  this R script contains the code for implementing D-learning [3].
- pls_gl.R: <br /> 
  this R script contains the code for l1-PLS with group lasso [4,5].
- pls_hgl.R: <br /> 
  this R script contains the code for l1-PLS with hierarchical group lasso [4,6].



References<br />
[1] Tao Y andWang L. Adaptive contrast weighted learning for multi-stage multi-treatment decision-making. Biometrics
2017; 73(1): 145–155.<br />
[2] Logan BR, Sparapani R, McCulloch RE et al. Decision making and uncertainty quantification for individualized treatments using bayesian additive regression trees. Stat Method Med Res 2019; 28(4): 1079–1093.<br />
[3] Qi Z and Liu Y. D-learning to estimate optimal individual treatment rules. Electron J Stat 2018; 12(2): 3601–3638.<br />
[4] Qian M and Murphy SA. Performance guarantees for individualized treatment rules. Ann Stat 2011; 39(2): 1180–1210.<br />
[5] Yuan M and Lin Y. Model selection and estimation in regression with grouped variables. J R Stat Soc B 2006; 68(1): 49–67.<br />
[6] Lim M and Hastie T. Learning interactions via hierarchical group-lasso regularization. J Comput Graph Stat 2015; 24(3): 627–654.
