#_______________________________________________________________________________         
#   About: Implementation of Pseudo- R2 to compare models
#_______________________________________________________________________________

#-------------------------------------------------------------------------------
# Import data, functions and libraries

serieA_2122<- read.csv("data/serieA_21-22.csv")
teams <- names(table(serieA_2122[,"HomeTeam"]))

source("functions/DC_tau.R")
source("functions/DC_joint_probability.R")
source("functions/Maher_joint_probability.R")
source("functions/DC_HDA_probabilities.R")
source("functions/Maher_HDA_probabilities.R")
source("functions/DC_pseudoR2_matchday.R")
source("functions/Maher_pseudoR2_matchday.R")

library(ggplot2)
#-------------------------------------------------------------------------------


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# PSEUDO-R2 FOR MAHER MODEL
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Load Maher parameters
load("parameters/Maher_parameters.RData")

Maher_pseudoR2=vector(mode="numeric",length=19)

for (match in 20:38){
    # Test set for the current matchday
    current_testset=serieA_2122[(10*match -9):(10*match),]
    # Add Pseudo-R2 of the current matchday
    i=match-19
    Maher_pseudoR2[i]<- Maher_pseudoR2_matchday(test=current_testset,
                                                current_par = Maher_parameters)
}

# Get a sort of Pseudo-R2 timeseries
Maher_pseudoR2_timeseries<- Maher_pseudoR2^(1/10)
# Get the overall Pseudo-R2
Maher_pseudoR2<- prod(Maher_pseudoR2)^(1/190)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# PSEUDO-R2 FOR DIXON-COLES STATIC MODEL
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DC_static_pseudoR2=vector(mode="numeric",length=19)
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
    DC_static_pseudoR2[i]= DC_pseudoR2_matchday(test=current_testset,
                                                current_par = current_matchday_staticDCpar)
}
# Get a sort of Brier Score timeseries
DC_static_pseudoR2_timeseries<- DC_static_pseudoR2^(1/10)
# Get the overall Brier Score
DC_static_pseudoR2<- prod(DC_static_pseudoR2)^(1/190)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# PSEUDO-R2 FOR DIXON-COLES DINAMIC MODEL
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DC_dinamic_pseudoR2=vector(mode="numeric",length=19)
for (match in 20:38){
    #test set for the current matchday
    current_testset=serieA_2122[(10*match -9):(10*match),]
    #load parameters estimated for the current matchday
    filepath= paste("parameters/DC_dinamic_parameters/par_list_",match,".RData",sep="")
    load(filepath)
    # The object loaded is called  "par_list"
    # Remember that indexes associated to static model (xi=0) are 1:4
    current_matchday_dinamicDCpar=par_list[21:24]
    i=match-19
    DC_dinamic_pseudoR2[i]= DC_pseudoR2_matchday(test=current_testset,
                                                 current_par = current_matchday_dinamicDCpar)
}
# Get a sort of Brier Score timeseries
DC_dinamic_pseudoR2_timeseries<- DC_dinamic_pseudoR2^(1/10)
# Get the overall Brier Score
DC_dinamic_pseudoR2<- prod(DC_dinamic_pseudoR2)^(1/190)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# OVERALL PSEUDO-R2 MODELS COMPARISON
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Maher_pseudoR2
DC_static_pseudoR2
DC_dinamic_pseudoR2
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# PSEUDO-R2 MODELS COMPARISON  OVER TIME
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Dataframe for pseudo-R2 timeseries
pseudoR2_timeseries_df <- data.frame(
    Matchday = rep(20:38,3),
    R2= c(Maher_pseudoR2_timeseries,
          DC_static_pseudoR2_timeseries,
          DC_dinamic_pseudoR2_timeseries
          ),
    Model=c(rep("Maher",19),
            rep("Static D-C",19),
            rep("Dinamic D-C",19))
)

# Plot
ggplot(pseudoR2_timeseries_df, aes(x = Matchday, y = R2)) + 
    geom_line(aes(color = Model), linewidth = 0.7) +
    ylab(expression("Pseudo -"~R^2))+
    scale_color_manual(values= c("#00bfff", "#ffb400", "indianred1")) +
    ggtitle(expression(bold("Pseudo -"~R^'2'~"over time")))+
    theme(plot.title = element_text(hjust = 0.5,face="bold"),
          axis.text=element_text(size=12),
          axis.title=element_text(size=12,face="plain"))
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
