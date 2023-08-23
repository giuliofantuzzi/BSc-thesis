#_______________________________________________________________________________         
#   About: Dixon-Coles static log-likelihood
#          sum-to-zero costraints are respected
#          rho costraint is respected
#_______________________________________________________________________________  

DC_static_loglike<- function(parameters,data){
    #------------------------------------------
    # Implicit sum-to-zero costraint
    param_list <- DC_relist_params(parameters)
    att<- param_list$att
    def<- param_list$def
    home<- as.numeric(param_list$home)
    rho<- as.numeric(param_list$rho)
    #------------------------------------------
    loglike<- 0
    for (k in 1:nrow(data)){
        #-----------------------------------------------------------------------
        # Get data and coefficients for the current row loglike 
        x<- data[k,"FTHG"]
        y<- data[k,"FTAG"]
        lambda<- exp(att[data[k,"HomeTeam"]]+ def[data[k,"AwayTeam"]] + home)
        mu<- exp(att[data[k,"AwayTeam"]]+ def[data[k,"HomeTeam"]])
        #-----------------------------------------------------------------------
        # if-else to ensure rho constraint ("brutal" but effective way)
        if ((rho > max(c(-1/lambda,-1/mu))) & (rho < min(c(1,1/(lambda*mu))))){
            loglike = loglike+ (log(DC_tau(x,y,lambda,mu,rho))+
                                dpois(x,lambda,log=TRUE)+
                                dpois(y,mu,log=TRUE))
        }
        else{return(-Inf)}
        #-----------------------------------------------------------------------
    }
    return(-loglike)
}