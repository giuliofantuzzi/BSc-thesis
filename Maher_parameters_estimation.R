#_______________________________________________________________________________         
#   About: parameters estimation for Maher model
#          Coefficients have a "named-list" structure
#          - Attack --> Maher_parameters$att
#          - Defence--> Maher_parameters$def
#_______________________________________________________________________________         

#-------------------------------------------------------------------------------
# Import data,functions and libraries
serieA_2122<- read.csv("data/serieA_21-22.csv")
teams<- names(table(serieA_2122[,"HomeTeam"]))

source("functions/loglike/Maher_loglike.R")
source("functions/Maher_relist_params.R")

library(dplyr)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Parameters estimation

# Initial guess
parameters_guess <- list( att = rep(0.5, length(teams)) %>% `names<-`(teams),
                          def = rep(0.5, length(teams)) %>% `names<-`(teams)
                          )

# Optimization
Maher_opt <- optim(par= unlist(parameters_guess),
                          fn=Maher_loglike, 
                          data=serieA_2122,
                          hessian = TRUE
                          )
#-------------------------------------------------------------------------------
# Relist parameters
Maher_parameters<- Maher_relist_params(Maher_opt$par)
# Hessian
Maher_hessian<- Maher_opt$hessian
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# To import parameters in future avoiding another estimation:
save(Maher_parameters,file = "parameters/Maher_parameters.RData")
save(Maher_hessian, file="parameters/hessian/Maher_hessian.RData")
#-------------------------------------------------------------------------------
