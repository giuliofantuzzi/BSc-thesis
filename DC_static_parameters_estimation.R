#_______________________________________________________________________________         
#   About: parameters estimation for Dixon-Coles model (static version)
#          Coefficients have a "named-list" structure
#          - Attack      --> DC_static_parameters$att
#          - Defence     --> DC_static_parameters$def
#          - Home effect --> DC_static_parameters$home
#          - Corr effect --> DC_static_parameters$rho
#_______________________________________________________________________________          

#-------------------------------------------------------------------------------
# Import data
serieA_2122<- read.csv("data/serieA_21-22.csv")
teams <- names(table(serieA_2122[,"HomeTeam"]))

# Import libraries and functions
library(dplyr) # needed for the function "DC_relist_params()"
source("functions/DC_relist_params.R")
source("functions/DC_tau.R")
source("functions/loglike/DC_static_loglike.R")
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#Parameters estimation

#Initial guess
parameters_guess <- list(
    att = rep(0, length(teams)-1) %>% `names<-`(teams[2:length(teams)]),
    def = rep(0, length(teams)-1) %>% `names<-`(teams[2:length(teams)]),
    home = 2,
    rho = 0)
# Notice that the number of parameters is 2n instead of 2n+2 because of the sum-to-zero costraints
# The function "DC_relist_params()" will manage this

# Optim preferences
user_dots <- list(maxit = 100,
                  method = "BFGS",
                  interval = "profile",
                  hessian = FALSE)

# Optimal parameters estimation
DC_static_parameters= optim(par = unlist(parameters_guess),
                     fn = DC_static_loglike,
                     data=serieA_2122,
                     method = user_dots$method,
                     hessian = user_dots$hessian,
                     control = list(maxit = user_dots$maxit))$par
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Relist parameters
DC_static_parameters<-DC_relist_params(DC_static_parameters)
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Save/load parameters
save(DC_static_parameters, file = "parameters/DC_static_parameters.RData")
load("parameters/DC_static_parameters.RData")
#-------------------------------------------------------------------------------
