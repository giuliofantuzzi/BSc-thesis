#_______________________________________________________________________________         
#   About: parameters estimation for Maher model
#          Coefficients have a "named-list" structure
#          - Attack --> maherparams$att
#          - Defence--> maherparams$def
#_______________________________________________________________________________         

#-------------------------------------------------------------------------------
# Import data and functions
serieA_2122<- read.csv("data/serieA_21-22.csv")
teams<- names(table(serieA_2122[,"HomeTeam"]))
source("functions/loglike/Maher_loglike.R")
source("functions/Maher_relist_params.R")
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Parameters estimation

# Initial guess
parameters_guess <- list( att = rep(0.5, length(teams)) %>% `names<-`(teams),
                          def = rep(0.5, length(teams)) %>% `names<-`(teams)
                          )

# Optimization
Maher_parameters <- optim(par= unlist(parameters_guess),
                          fn=Maher_loglike, 
                          data=serieA_2122
                          )$par
#-------------------------------------------------------------------------------
Maher_parameters<- Maher_relist_params(Maher_parameters)
#-------------------------------------------------------------------------------
# To import parameters in future avoiding another estimation:
save(Maher_parameters,file = "parameters/Maher_parameters.RData")
load("parameters/Maher_parameters.RData")
#-------------------------------------------------------------------------------