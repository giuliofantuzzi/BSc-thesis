#_______________________________________________________________________________         
#   About: loglike function for Maher model
#_______________________________________________________________________________         

Maher_loglike<- function(parameters, data) {
    n= length(parameters)/2
    alpha= parameters[1:n]
    beta= parameters[(n+1):(2*n)]
    n_rows<- nrow(data)
    loglike<- 0
    for (k in 1:n_rows){
        x<- data[k,"FTHG"]
        y<- data[k,"FTAG"]
        lambda<- alpha[data[k,"HomeDummy"]]* beta[data[k,"AwayDummy"]]
        mu<- alpha[data[k,"AwayDummy"]]* beta[data[k,"HomeDummy"]]
        loglike = loglike+ (log(dpois(x,lambda)) + log(dpois(y,mu)))
    }
    return(-loglike) # Remember that max(f(x)) = -min(-f(x))
}