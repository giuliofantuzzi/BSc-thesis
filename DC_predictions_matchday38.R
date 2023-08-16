#_______________________________________________________________________________         
#   About:  Application of Dixon-Coles (best) dinamic model to predict
#           football outcomes of the last matchday (38th)
#_______________________________________________________________________________         

#-------------------------------------------------------------------------------
# Import data, functions and libraries
serieA_2122<- read.csv("data/serieA_21-22.csv")

source("functions/DC_tau.R")
source("functions/DC_joint_probability.R")
source("functions/DC_result_heatmap.R")

library(ggplot2)
#install.packages("patchwork")
library(patchwork)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Import parameters to predict 38th matchday
load("parameters/DC_dinamic_parameters/par_list_38.RData")
# Remember: Parameters associated to best xi (0.005) are stored in indexes 21:24
DC_dinamic_par<-par_list[21:24]
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Examples of running the function
DC_result_heatmap('Sassuolo','Milan',DC_dinamic_par)
DC_result_heatmap('Inter','Sampdoria',DC_dinamic_par)
DC_result_heatmap('Venezia','Cagliari',DC_dinamic_par)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Apply function DC_result_heatmap() to all matches of matchday 38

matchday38<- serieA_2122[371:380,]

Heatmaps = lapply(1:10, function(i){
    #Get current team names
    teamH<- matchday38[i,"HomeTeam"]
    teamA<- matchday38[i,"AwayTeam"]
    #Heatmap of the current match
    DC_result_heatmap(teamH,teamA,DC_dinamic_par)
    })

# Unique grid with all the heatmaps
# (Plot appearance changes according to dimensions of the plot panel in Rstudio)
(Heatmaps[[1]] / Heatmaps[[2]] /Heatmaps[[3]] / Heatmaps[[4]] / Heatmaps[[5]])|  
(Heatmaps[[6]] /Heatmaps[[7]] /Heatmaps[[8]] / Heatmaps[[9]] / Heatmaps[[10]])
#-------------------------------------------------------------------------------
