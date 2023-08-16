#_______________________________________________________________________________
# About: Implementation of confusion matrices to compare models's performances
#        Comparison between static and dinamic versions of Dixon-Coles model
#_______________________________________________________________________________

#-------------------------------------------------------------------------------
# Import data, functions and libraries
serieA_2122<- read.csv("data/serieA_21-22.csv")
teams <- names(table(serieA_2122[,"HomeTeam"]))

source("functions/DC_tau.R")
source("functions/DC_joint_probability.R")
source("functions/DC_HDA_probabilities.R")
source("functions/result_HDA.R")
source("functions/result_1X_2.R")
source("functions/result_1_X2.R")
source("functions/plot_confusionmatrix.R")

library(ggplot2)
library(tibble)
library(cvms)
library(patchwork)
#-------------------------------------------------------------------------------


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%% STEP 1: CALCULATE MODELS PREDICTIONS %%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#-------------------------------------------------------------------------------
# STATIC DIXON-COLES PREDICTIONS
#-------------------------------------------------------------------------------

# Empty arrays for predictions
DC_static_predictions_HDA<- vector(mode="character",length=190)
DC_static_predictions_1X_2<- vector(mode="character",length=190)
DC_static_predictions_1_X2<- vector(mode="character",length=190)

# Index to fill above arrays
i=1

# Iteration over the 2nd half of the league matches
for (match in 20:38){
    #test set for the current matchday
    current_testset=serieA_2122[(10*match -9):(10*match),]
    #load parameters estimated for the current matchday
    filepath= paste("parameters/DC_dinamic_parameters/par_list_",match,".RData",sep="")
    load(filepath)
    # The object loaded is called  "par_list"
    # Remember that parameters indexes of the static model are 1:4
    current_matchday_par=par_list[1:4]
    
    current_matchday_predictions_HDA<- vector(mode="character",length=10)
    current_matchday_predictions_1X_2<- vector(mode="character",length=10)
    current_matchday_predictions_1_X2<- vector(mode="character",length=10)
    for (m in 1:nrow(current_testset)){
        # Get match teams
        teamA= current_testset[m,"HomeTeam"]
        teamB= current_testset[m,"AwayTeam"]
        # Get the real result of the match
        real_result= current_testset[m,"FTR"]
        # Get probabilities H-D-A
        HDA_probs=DC_HDA_probabilities(teamA,teamB,current_matchday_par)
        # Predict H-D-A, 1X-2 and 1-X2 
        predicted_FTR=  result_HDA(HDA_probs)
        predicted_1X_2=  result_1X_2(HDA_probs)
        predicted_1_X2=  result_1_X2(HDA_probs)
        # Insert predictions into arrays
        current_matchday_predictions_HDA[m]=predicted_FTR
        current_matchday_predictions_1X_2[m]=predicted_1X_2
        current_matchday_predictions_1_X2[m]=predicted_1_X2
    }
    # Update predictions arrays
    DC_static_predictions_HDA[i:(i+9)]<-current_matchday_predictions_HDA
    DC_static_predictions_1X_2[i:(i+9)]<-current_matchday_predictions_1X_2
    DC_static_predictions_1_X2[i:(i+9)]<-current_matchday_predictions_1_X2
    # Update index i
    i=i+10
}


#-------------------------------------------------------------------------------
# STATIC DIXON-COLES PREDICTIONS
#-------------------------------------------------------------------------------

# Empty arrays for predictions
DC_dinamic_predictions_HDA<- vector(mode="character",length=190)
DC_dinamic_predictions_1X_2<- vector(mode="character",length=190)
DC_dinamic_predictions_1_X2<- vector(mode="character",length=190)

# Index to fill above arrays
i=1

# Iteration over the 2nd half of the league matches
for (match in 20:38){
    #test set for the current matchday
    current_testset=serieA_2122[(10*match -9):(10*match),]
    #load parameters estimated for the current matchday
    filepath= paste("parameters/DC_dinamic_parameters/par_list_",match,".RData",sep="")
    load(filepath)
    # The object loaded is called  "par_list"
    # Remember that parameters indexes of the best dinamic are 21:24
    current_matchday_par=par_list[21:24]
    
    current_matchday_predictions_HDA<- vector(mode="character",length=10)
    current_matchday_predictions_1X_2<- vector(mode="character",length=10)
    current_matchday_predictions_1_X2<- vector(mode="character",length=10)
    for (m in 1:nrow(current_testset)){
        # Get match teams
        teamA= current_testset[m,"HomeTeam"]
        teamB= current_testset[m,"AwayTeam"]
        # Get the real result of the match
        real_result= current_testset[m,"FTR"]
        # Get probabilities H-D-A
        HDA_probs=DC_HDA_probabilities(teamA,teamB,current_matchday_par)
        # Predict H-D-A, 1X-2 and 1-X2 
        predicted_FTR=  result_HDA(HDA_probs)
        predicted_1X_2=  result_1X_2(HDA_probs)
        predicted_1_X2=  result_1_X2(HDA_probs)
        # Insert predictions into array
        current_matchday_predictions_HDA[m]=predicted_FTR
        current_matchday_predictions_1X_2[m]=predicted_1X_2
        current_matchday_predictions_1_X2[m]=predicted_1_X2
    }
    # Update predictions arrays
    DC_dinamic_predictions_HDA[i:(i+9)]<-current_matchday_predictions_HDA
    DC_dinamic_predictions_1X_2[i:(i+9)]<-current_matchday_predictions_1X_2
    DC_dinamic_predictions_1_X2[i:(i+9)]<-current_matchday_predictions_1_X2
    # Update index i
    i=i+10
}


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%% STEP 2: CORRELATION MATRICES %%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#-------------------------------------------------------------------------------
# (1) Correlation matrices analysis with H-D-A classes
#-------------------------------------------------------------------------------

league_2nd_round_HDA<- serieA_2122[191:380,]
league_2nd_round_HDA$DCstaticpredictions= DC_static_predictions_HDA
league_2nd_round_HDA$DCdinamicpredictions= DC_dinamic_predictions_HDA

#Feature selection
league_2nd_round_HDA<- league_2nd_round_HDA[,c("FTR","DCstaticpredictions", "DCdinamicpredictions")]

#Confusion Matrices
DCstatic_conf_mat_HDA<- confusion_matrix(targets = as.factor(league_2nd_round_HDA$FTR),
                                         predictions =as.factor(league_2nd_round_HDA$DCstaticpredictions)
                                         
)
DCdinamic_conf_mat_HDA<- confusion_matrix(targets = as.factor(league_2nd_round_HDA$FTR),
                                          predictions =as.factor(league_2nd_round_HDA$DCdinamicpredictions)
)

# Plots
p1=plot_confusionmatrix(DCstatic_conf_mat_HDA,"Dixon-Coles model (static)")
p2=plot_confusionmatrix(DCdinamic_conf_mat_HDA,"Dixon-Coles model (dinamic)")

p1 + theme(plot.margin = unit(c(0,40,0,0), "pt")) +
(p2 + theme(plot.margin = unit(c(0,40,0,0), "pt")))


#-------------------------------------------------------------------------------
# (2) Correlation matrices analysis with 1X - 2 classes
#-------------------------------------------------------------------------------
league_2nd_round_1X_2<- serieA_2122[191:380,]
league_2nd_round_1X_2$DCstaticpredictions_1X_2= DC_static_predictions_1X_2
league_2nd_round_1X_2$DCdinamicpredictions_1X_2= DC_dinamic_predictions_1X_2

# Feature selection
league_2nd_round_1X_2<- league_2nd_round_1X_2[,c("FTR","DCstaticpredictions_1X_2", "DCdinamicpredictions_1X_2")]

# Convert FTR into the logic of 1X (HomeTeam doesn't lose) and 2 (loses)
# FTR will be always TRUE
league_2nd_round_1X_2$FTR_target= TRUE
# Except when FTR=A (because HomeTeam looses)
league_2nd_round_1X_2$FTR_target[league_2nd_round_1X_2$FTR == 'A']= FALSE

# Now convert in TRUE-FALSE our models predictions
league_2nd_round_1X_2$DCstaticpredictions_1X_2=ifelse(league_2nd_round_1X_2$DCstaticpredictions_1X_2 == "1X", TRUE, FALSE)
league_2nd_round_1X_2$DCdinamicpredictions_1X_2=ifelse(league_2nd_round_1X_2$DCdinamicpredictions_1X_2 == "1X", TRUE, FALSE)

# Confusion Matrices
DCstatic_conf_mat_1X_2<- confusion_matrix(targets = league_2nd_round_1X_2$FTR_target,
                                          predictions =league_2nd_round_1X_2$DCstaticpredictions_1X_2
)
DCdinamic_conf_mat_1X_2<- confusion_matrix(targets =league_2nd_round_1X_2$FTR_target,
                                           predictions =league_2nd_round_1X_2$DCdinamicpredictions_1X_2
)

# Plots
p3=plot_confusionmatrix(DCstatic_conf_mat_1X_2,"Dixon-Coles model (static)")
p4=plot_confusionmatrix(DCdinamic_conf_mat_1X_2,"Dixon-Coles model (dinamic)")

(p3 + theme(plot.margin = unit(c(0,35,0,0), "pt"))) +
(p4 + theme(plot.margin = unit(c(0,35,0,0), "pt")))




#-------------------------------------------------------------------------------
# (3) Correlation matrices analysis with 1 - X2 classes
#-------------------------------------------------------------------------------
league_2nd_round_1_X2<- serieA_2122[191:380,]
league_2nd_round_1_X2$DCstaticpredictions_1_X2= DC_static_predictions_1_X2
league_2nd_round_1_X2$DCdinamicpredictions_1_X2= DC_dinamic_predictions_1_X2

#Feature selection
league_2nd_round_1_X2<- league_2nd_round_1_X2[,c("FTR","DCstaticpredictions_1_X2", "DCdinamicpredictions_1_X2")]

# Convert FTR into the logic of X2 (Away teams doesn't lose) and 1 (loses)
# FTR will be always TRUE
league_2nd_round_1_X2$FTR_target= TRUE
# Except when FTR=H (because AwayTeam looses)
league_2nd_round_1_X2$FTR_target[league_2nd_round_1_X2$FTR == 'H']= FALSE

# Now convert in TRUE-FALSE our models predictions
league_2nd_round_1_X2$DCstaticpredictions_1_X2=ifelse(league_2nd_round_1_X2$DCstaticpredictions_1_X2 == "X2", TRUE, FALSE)
league_2nd_round_1_X2$DCdinamicpredictions_1_X2=ifelse(league_2nd_round_1_X2$DCdinamicpredictions_1_X2 == "X2", TRUE, FALSE)

# Confusion Matrices
DCstatic_conf_mat_1_X2<- confusion_matrix(targets = league_2nd_round_1_X2$FTR_target,
                                          predictions =league_2nd_round_1_X2$DCstaticpredictions_1_X2
)
DCdinamic_conf_mat_1_X2<- confusion_matrix(targets =league_2nd_round_1_X2$FTR_target,
                                           predictions =league_2nd_round_1_X2$DCdinamicpredictions_1_X2
)

# Plots
p4=plot_confusionmatrix(DCstatic_conf_mat_1_X2,"Dixon-Coles model (static)")
p5=plot_confusionmatrix(DCdinamic_conf_mat_1_X2,"Dixon-Coles model (dinamic)")

(p4 + theme(plot.margin = unit(c(0,35,0,0), "pt"))) +
(p5 + theme(plot.margin = unit(c(0,35,0,0), "pt")))
