#_______________________________________________________________________________         
#   About: parameters estimation for Maher model
#          Coefficients have a "named-list" structure
#          - Attack --> maherparams$att
#          - Defence--> maherparams$def
#_______________________________________________________________________________         

#-------------------------------------------------------------------------------
# Import serie A 21-22 data
serieA_2122<- read.csv("data/serieA_21-22.csv")
# Get teams's name
teams<- names(table(serieA_2122[,"HomeTeam"]))
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Parameters estimation

# Import Maher loglike
source("functions/loglike/Maher_loglike.R")

# Initial guess
parameters_guess= rep(0.5,40)#both attack and defense parameters (tot= 2n)

# Optimization
Maher_parameters <- optim(parameters_guess, Maher_loglike, 
                     data=serieA_2122)$par


names(Maher_parameters) <- rep(teams,2)

Maher_parameters<- list(
    att= Maher_parameters[1:20],
    def= Maher_parameters[21:40]
)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# To import parameters in future avoiding another estimation:
save(Maher_parameters,file = "parameters/Maher_parameters.RData")
load("parameters/Maher_parameters.RData")
#-------------------------------------------------------------------------------