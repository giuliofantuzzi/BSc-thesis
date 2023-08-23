#_______________________________________________________________________________
#   About    : this script is meant to obtain standard errors and confidence
#              intervals (95%) for models' estimates.
#   IMPORTANT: For Dixon-Coles estimation, sum-to-zero constraints were considered
#              I made this costraint being respected in a tricky way, when calling
#              the function DC_relist_parameters()
#              The idea was estimate all the parameters except Atalanta's ones
#              and then obtain them as the "negative-sum" of the others
#              Giving a measure of s.e and IC for Atalanta is not immediate
#              Some empirical methods may be used (e.g. bootstrap), but for this
#              analysis I decided to exclude atalanta!
#_______________________________________________________________________________


#-------------------------------------------------------------------------------
# 1) MAHER MODEL
load("parameters/Maher_parameters.RData")
load("parameters/hessian/Maher_hessian.RData")

Maher_se= sqrt(diag(solve(Maher_hessian)))
Maher_lower= as.numeric(unlist(Maher_parameters)) - 1.96*as.numeric(Maher_se)/sqrt(380)
Maher_upper= as.numeric(unlist(Maher_parameters)) + 1.96*as.numeric(Maher_se)/sqrt(380)

round(Maher_se, digits=3)
round(Maher_lower, digits=3)
round(Maher_upper, digits=3)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# 2) STATIC DIXON-COLES MODEL
load("parameters/DC_static_parameters.RData")
load("parameters/hessian/DC_static_hessian.RData")

# Remember: we don't include the first team (Atalanta) in these calculations
# We remove atalanta parameters by using -c(1,21) !
DC_static_se= sqrt(diag(solve(DC_static_hessian)))
DC_static_lower= as.numeric(unlist(DC_static_parameters)[-c(1,21)]) - 1.96*as.numeric(DC_static_se)/sqrt(380)
DC_static_upper= as.numeric(unlist(DC_static_parameters)[-c(1,21)]) + 1.96*as.numeric(DC_static_se)/sqrt(380)

round(DC_static_se, digits=3)
round(DC_static_lower, digits=3)
round(DC_static_lower, digits=3)
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# 3) DINAMIC DIXON-COLES MODEL

# NB: in PLL I decided to set hessian=F (and maxit=15) to reduce estimation time
# Now re-estimate parameters to predict last matchday using maxit=100 and hess=T

serieA_2122<- read.csv("data/serieA_21-22.csv")
teams <- names(table(serieA_2122[,"HomeTeam"]))

source("functions/loglike/DC_dinamic_loglike.R")
source("functions/DC_tau.R")
source("functions/add_date_difference.R")
source("functions/DC_relist_params.R")
library(dplyr)

serieA_2122<- add_date_difference(serieA_2122)
#Remember that in add_date_difference(), if not specified, test=training

# Optimization

# to speed-up optimization algorithm use static DC parameters as initial guess!
load("parameters/DC_static_parameters.RData")

parameters_guess<- list(att = DC_static_parameters$att[2:20],
                        def = DC_static_parameters$def[2:20],
                        home = as.numeric(DC_static_parameters$home),
                        rho = as.numeric(DC_static_parameters$rho)
                        )

user_dots <- list(maxit = 100, 
                  method = "BFGS",
                  interval = "profile",
                  hessian = TRUE)

DC_dinamic_opt= optim(par = unlist(parameters_guess),
                     fn = DC_dinamic_loglike,
                     data= serieA_2122,
                     xi=0.005,
                     method = user_dots$method,
                     hessian = user_dots$hessian,
                     control = list(maxit = user_dots$maxit)
                     )

#-------------------------------------------------------------------------------
# Get parameters and hessian

# Relist parameters
DC_dinamic_parameters<-DC_relist_params(DC_dinamic_opt$par)
# Hessian
DC_dinamic_hessian<- DC_dinamic_opt$hessian

#-------------------------------------------------------------------------------
# Save/load parameters
save(DC_dinamic_parameters, file = "parameters/DC_dinamic_parameters/DC_dinamic_parameters.RData")
save(DC_dinamic_hessian, file="parameters/hessian/DC_dinamic_hessian.RData")
#-------------------------------------------------------------------------------
load("parameters/DC_dinamic_parameters/DC_dinamic_parameters.RData")
load("parameters/hessian/DC_dinamic_hessian.RData")

# We won't consider Atalanta parameters
DC_dinamic_se= sqrt(diag(solve(DC_dinamic_hessian)))
DC_dinamic_lower= as.numeric(unlist(DC_dinamic_parameters)[-c(1,21)]) - 1.96*as.numeric(DC_dinamic_se)/sqrt(380)
DC_dinamic_upper= as.numeric(unlist(DC_dinamic_parameters)[-c(1,21)]) + 1.96*as.numeric(DC_dinamic_se)/sqrt(380)

#-------------------------------------------------------------------------------
