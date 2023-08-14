#_______________________________________________________________________________         
#   About: ~ Parameters estimation for Dixon-Coles model (dinamic version)
#
#          ~ For the i-th matchday (seconf half of the league--> i=20,...38)
#            the list of optimal parameters will be saved as "par_list_i.RData"
#            Notation "i" means that we want to estimate the model to predict the
#            i-th matchday, so our training set will be from matchday 1 to (i-1)
#
#          ~ Since we'll implement a profile log-likelihood approach, we estimate
#            our parameters using (n) different values of xi (for each matchday)
#
#          ~ par_list_i will have the following structure:
#            (opt_par_xi0, opt_par_xi1, ... , opt_par_xin)
#            where the generic opt_par_xij contains the optimal parameters of the
#            model associated to the j-th value of xi. Its structure will be:
#            (opt_par_xij$att, opt_par_xij$def, opt_par_xij$home, opt_par_xij$rho)
#_______________________________________________________________________________     

#-------------------------------------------------------------------------------
# Import data
serieA_2122<- read.csv("data/serieA_21-22.csv")
teams <- names(table(serieA_2122[,"HomeTeam"]))

# Import libraries and functions
library(dplyr)
source("functions/DC_tau.R")
source("functions/DC_relist_params.R")
source("functions/add_date_difference.R")
source("functions/loglike/DC_dinamic_loglike.R")
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
#........................OPTIMIZATION GLOBAL SETTINGS...........................
#-------------------------------------------------------------------------------

# Remember that we already estimated DC static parameters on the entire season
# To speed-up the optimization phase we will use them as initial guess
# So the optimization algorithm should converge to the solution faster!

# Initial guess
load("parameters/DC_static_parameters.RData")
parameters_guess<- list(att = DC_static_parameters$att[2:20],
                        def = DC_static_parameters$def[2:20],
                        home = as.numeric(DC_static_parameters$home),
                        rho = as.numeric(DC_static_parameters$rho)
                        )

# Optim preferences
user_dots <- list(maxit = 15, 
                  method = "BFGS",
                  interval = "profile",
                  hessian = FALSE)

# Array of some different xi values
xi_values<- seq(from=0, to=0.01, by = 0.001)
# Notice that xi=0 corresponds to the static version of Dixon-Coles model!

#-------------------------------------------------------------------------------
#.........PARAMETERS ESTIMATION OVER THE SECOND HALF OF THE LEAGUE..............
#-------------------------------------------------------------------------------

for (i in 20:38){
    
    cat("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")
    cat("Parameters estimation to predict matchday n.",i,"...\n")
    cat("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")
    
    #---------------------------------------------------------------------------
    # (1) Training and test set for the current matchday
    training= serieA_2122[1:(10*(i-1)),] 
    test=serieA_2122[(10*i -9):(10*i),]
    # Add date differencies to the training set
    training<- add_date_difference(training,test) 
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    # Empty list where optimal parameters for each matchday will be appended
    par_list= list()
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    # (2) Iteration over all xi values
    cat("----------------------------------------------------\n")
    for(xi in xi_values){
        cat("Model associated to xi = ",xi,"...\n")
        # Get optimal parameters (associated to the current value of xi)
        DC_dinamic_parameters_xi= optim(par = unlist(parameters_guess),
                                     fn = DC_dinamic_loglike,
                                     data=training,
                                     xi= xi,
                                     method = user_dots$method,
                                     hessian = user_dots$hessian,
                                     control = list(maxit = user_dots$maxit))$par
        
        # Remember to re-list the estimated parameters
        DC_dinamic_parameters_xi<-DC_relist_params(DC_dinamic_parameters_xi)
        #li aggiungo alla lista dei parametri
        par_list= append(par_list,DC_dinamic_parameters_xi)
        
        cat("Estimation using xi=",xi,"DONE!\n")
    }
    cat("----------------------------------------------------\n")
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    # Save optimal parameters of the current matchday
    cat("....................................................\n")
    cat("Saving parameters of matchday n.",i,"...\n")
    cat("....................................................\n")
    
    filepath= paste("parameters/DC_dinamic_parameters/par_list_",i,".RData",sep="")
    save(par_list,file = filepath) 
    #---------------------------------------------------------------------------
}
