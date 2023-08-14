#_______________________________________________________________________________         
#   About: loglike function for Maher model
#_______________________________________________________________________________         

Maher_loglike<- function(parameters, data) {
    param_list <- Maher_relist_params(parameters)
    att<- param_list$att
    def<- param_list$def
    
    loglike<- 0
    for (k in 1:nrow(data)){
        x<- data[k,"FTHG"]
        y<- data[k,"FTAG"]
        lambda<- att[data[k,"HomeTeam"]]* def[data[k,"AwayTeam"]]
        mu<- att[data[k,"AwayTeam"]]* def[data[k,"HomeTeam"]]
        loglike = loglike+ (log(dpois(x,lambda)) + log(dpois(y,mu)))
    }
    return(-loglike) # Remember that max(f(x)) = -min(-f(x))
}