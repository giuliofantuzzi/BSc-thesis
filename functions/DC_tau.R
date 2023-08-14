#_______________________________________________________________________________         
#   About: Dixon and Coles Tau funcion.
#          Used to correct the correlation for "few-goals"/draw matches.
#_______________________________________________________________________________         

DC_tau<- function(x,y,lambda, mu, rho){
    if (x==0 & y==0){return(1- lambda*mu*rho)}
    else if (x==0 & y==1){return(1+lambda*rho)}
    else if (x==1 & y==0){return(1+mu*rho)}
    else if (x==1 & y==1){return(1-rho)}
    else{return(1)}
}

