#_______________________________________________________________________________         
#   About:    Given the following parameters:
#               - home goals (x)
#               - away goals (y)
#               - home team name (teamH)
#               - away team name (teamA)
#               - Dixon-Coles coefficients (par) 
#             The function returns the probability of getting that result
#_______________________________________________________________________________  

DC_joint_probability <- function(x, y,teamH,teamA,par){
    lambda= exp(as.numeric(par$att[teamH])+as.numeric(par$def[teamA])+as.numeric(par$home))
    mu= exp(as.numeric(par$att[teamA])+as.numeric(par$def[teamH]))
    prob = DC_tau(x,y,lambda,mu,as.numeric(par$rho))*dpois(x,lambda)*dpois(y,mu)
    return(prob)
}

