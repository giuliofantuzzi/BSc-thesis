#_______________________________________________________________________________         
#   About: football abilities over the second half of the league
#_______________________________________________________________________________     

#-------------------------------------------------------------------------------
# Import data, libraries and functions
serieA_2122<- read.csv("data/serieA_21-22.csv")
teams <- names(table(serieA_2122[,"HomeTeam"]))
library(ggplot2)
source("functions/plot_parameters_ts.R")
#install.packages("patchwork")
library(patchwork)
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Examples of running the function
plot_parameters_ts('Milan')
plot_parameters_ts('Roma')
plot_parameters_ts('Napoli')
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Apply function plot_parameters_ts() to all teams of the league
Plots = lapply(1:20, function(i){
    #Get current team name
    team= teams[i]
    # Time series of team abilities
    plot_parameters_ts(team)
})

# Unique grid with all the plots
# (Plot appearance changes according to dimensions of the plot panel in Rstudio)
(Plots[[1]] | Plots[[2]] |Plots[[3]] | Plots[[4]]) /
    (Plots[[5]] | Plots[[6]] |Plots[[7]] | Plots[[8]]) /
    (Plots[[9]] | Plots[[10]] |Plots[[11]] | Plots[[12]]) /
    (Plots[[13]] | Plots[[14]] |Plots[[15]] | Plots[[16]]) /
    (Plots[[17]] | Plots[[18]] |Plots[[19]] | Plots[[20]])
#-------------------------------------------------------------------------------
