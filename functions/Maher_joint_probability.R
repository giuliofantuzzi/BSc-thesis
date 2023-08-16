#_______________________________________________________________________________         
#   About: given the following parameters:
#           - home goals (x)
#           - away goals (y)
#           - home team name (teamH)
#           - away team name (teamA)
#           - Maher coefficients (par) 
#          Returns the joint probability of getting that result
#_______________________________________________________________________________  

Maher_joint_probability <- function(x, y,teamH,teamA,par){
    lambda= exp(as.numeric(par$att[teamH])+as.numeric(par$def[teamA]))
    mu= exp(as.numeric(par$att[teamA])+as.numeric(par$def[teamH]))
    prob = dpois(x,lambda)*dpois(y,mu)
    return(prob)
}
