#_______________________________________________________________________________         
#   About: Implementation of Brier score to determine the best model
#_______________________________________________________________________________  
#...............................................................................
# Import data, functions and libraries

serieA_2122<- read.csv("data/serieA_21-22.csv")
teams <- names(table(serieA_2122[,"HomeTeam"]))

source("functions/DC_tau.R")
source("functions/DC_joint_probability.R")
source("functions/Maher_joint_probability.R")
source("functions/DC_HDA_probabilities.R")
source("functions/Maher_HDA_probabilities.R")
source("functions/DC_brier_score_matchday.R")
source("functions/Maher_brier_score_matchday.R")

library(ggplot2)
#...............................................................................


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# BRIER SCORE FOR MAHER MODEL
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Load Maher parameters
load("parameters/Maher_parameters.RData")

Maher_BS=vector(mode="numeric",length=19)

for (match in 20:38){
    # Test set for the current matchday
    current_testset=serieA_2122[(10*match -9):(10*match),]
    # Add Brier Score of the current matchday
    i=match-19
    Maher_BS[i]<- Maher_brier_score_matchday(test=current_testset,
                                             current_par = Maher_parameters)
}

# Get a sort of Brier Score timeseries
Maher_BS_timeseries<- Maher_BS/10
# Get the overall Brier Score
Maher_BS<- sum(Maher_BS)/190
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# BRIER SCORE FOR DIXON-COLES STATIC MODEL
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DC_static_BS=vector(mode="numeric",length=19)
for (match in 20:38){
    #test set for the current matchday
    current_testset=serieA_2122[(10*match -9):(10*match),]
    #load parameters estimated for the current matchday
    filepath= paste("parameters/DC_dinamic_parameters/par_list_",match,".RData",sep="")
    load(filepath)
    # The object loaded is called  "par_list"
    # Remember that indexes associated to static model (xi=0) are 1:4
    current_matchday_staticDCpar=par_list[1:4]
    i=match-19
    DC_static_BS[i]= DC_brier_score_matchday(test=current_testset,
                                             current_par = current_matchday_staticDCpar)
}
# Get a sort of Brier Score timeseries
DC_static_BS_timeseries<- DC_static_BS/10
# Get the overall Brier Score
DC_static_BS<- sum(DC_static_BS)/190
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# BRIER SCORE FOR DIXON-COLES DINAMIC MODEL
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DC_dinamic_BS=vector(mode="numeric",length=19)
for (match in 20:38){
    #test set for the current matchday
    current_testset=serieA_2122[(10*match -9):(10*match),]
    #load parameters estimated for the current matchday
    filepath= paste("parameters/DC_dinamic_parameters/par_list_",match,".RData",sep="")
    load(filepath)
    # The object loaded is called  "par_list"
    # Remember that indexes associated to best dinamic model (xi=0.005) are 21:24
    current_matchday_dinamicDCpar=par_list[21:24]
    i=match-19
    DC_dinamic_BS[i]= DC_brier_score_matchday(test=current_testset,
                                              current_par = current_matchday_dinamicDCpar)
}
# Get a sort of Brier Score timeseries
DC_dinamic_BS_timeseries<- DC_dinamic_BS/10
# Get the overall Brier Score
DC_dinamic_BS<- sum(DC_dinamic_BS)/190
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# OVERALL BRIER SCORE MODELS COMPARISON
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Maher_BS
DC_static_BS
DC_dinamic_BS
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# BRIER SCORE MODELS COMPARISON  OVER TIME
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Dataframe for Brier-Score timeseries
BS_timeseries_df <- data.frame(
    Matchday = rep(20:38,3),
    BS= c(Maher_BS_timeseries,DC_static_BS_timeseries,DC_dinamic_BS_timeseries),
    Model=c(rep("Maher",19), rep("Static D-C",19), rep("Dinamic D-C",19))
)

# Plot
ggplot(BS_timeseries_df, aes(x = Matchday, y = BS)) + 
    geom_line(aes(color = Model), linewidth = 0.7) +
    ylab("Brier Score")+
    scale_color_manual(values= c("#00bfff", "#ffb400", "indianred1")) +
    ggtitle("Brier Score over time")+
    theme(plot.title = element_text(hjust = 0.5,face="bold"),
          axis.text=element_text(size=12),
          axis.title=element_text(size=12,face="plain"))
