#_______________________________________________________________________________         
#   About: profile loglike approach for Dixon-Coles dinamic model
#_______________________________________________________________________________  

#-------------------------------------------------------------------------------
# Import data, functions and libraries
serieA_2122<- read.csv("data/serieA_21-22.csv")
teams <- names(table(serieA_2122[,"HomeTeam"]))

source("functions/DC_tau.R")
source("functions/DC_relist_params.R")
source("functions/loglike/DC_dinamic_loglike.R")
source("functions/DC_joint_probability.R")
source("functions/DC_HDA_probabilities.R")
source("functions/PLL_matchday.R")

library(ggplot2)
#-------------------------------------------------------------------------------


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#...................PROFILE LOG-LIKELIHOOD APPROACH.............................
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#-------------------------------------------------------------------------------
# Xi values and corresponding indexes
xi_values<- seq(from=0, to=0.01, by = 0.001)
xi_indexes= list(1:4,5:8,9:12,13:16,17:20,21:24,
                25:28,29:32,33:36,37:40,41:44)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Empty array where S(xi) will be stored
S_xi=vector(mode="numeric",length = length(xi_values))
# In S_xi[i] will be stored the S(xi) associated to the i-th value of xi

for (match in 20:38){
    #---------------------------------------------------------------------------
    # Test set for the current match-day
    current_testset=serieA_2122[(10*match -9):(10*match),]
    #---------------------------------------------------------------------------
    # Load parameters estimated for the current matchday
    filepath= paste("parameters/DC_dinamic_parameters/par_list_",match,".RData",sep="")
    load(filepath) # The object loaded is called  "par_list"
    #---------------------------------------------------------------------------
    # Now calculate S(xi) of the current matchday
    # For loop to iterate on all xi values
    for(e in 1:length(xi_values)){
        current_xi_par=par_list[xi_indexes[[e]]]
        # Add the current S_m(xi) to the previous [S_{m-1}(xi)]
        S_xi[e]= S_xi[e]+ PLL_matchday(test=current_testset,
                                           current_par = current_xi_par)
    }
    #---------------------------------------------------------------------------
}
# Now we got a S_xi vector with the overall PLL
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# PPL PLOT
# Dataframe for ggplot
profile_loglike_df= data.frame(cbind(xi_values,S_xi))

ggplot(data = profile_loglike_df, aes(x = xi_values, y = S_xi)) +
    geom_line(colour="#154360",size=1)+
    geom_point(shape = 21, colour = "#154360", fill="#1ABC9C",size = 2, stroke=1.5)+
    xlab(expression(xi))+
    ylab(expression("S"~(xi)))+
    ggtitle("Profile log-likelihood (PLL)")+
    theme(plot.title = element_text(hjust = 0.5,face="bold"),
          axis.text=element_text(size=12),
          axis.title=element_text(size=14,face="bold"))
#-------------------------------------------------------------------------------