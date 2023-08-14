#_______________________________________________________________________________         
#   About:    Analysis of home effect in football matches
#_______________________________________________________________________________         

#-------------------------------------------------------------------------------
# Import dataset and libraries
serieA_2122<- read.csv("data/serieA_21-22.csv")
teams_list<- names(table(serieA_2122[,"HomeTeam"]))
library(ggplot2)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Define variables for goals scored/conceeded Home/Away
TeamHomeGoalsScored<- vector(mode="numeric", length=length(teams_list))
TeamAwayGoalsScored<- vector(mode="numeric", length=length(teams_list))
TeamHomeGoalsConceeded<- vector(mode="numeric", length=length(teams_list))
TeamAwayGoalsConceeded<- vector(mode="numeric", length=length(teams_list))

for (i in 1:length(teams_list)){
    TeamHomeGoalsScored[i]<- sum(serieA_2122[serieA_2122$HomeTeam== teams_list[i],"FTHG"])
    TeamAwayGoalsScored[i]<- sum(serieA_2122[serieA_2122$AwayTeam==teams_list[i],"FTAG"])
    TeamHomeGoalsConceeded[i]<- sum(serieA_2122[serieA_2122$HomeTeam== teams_list[i],"FTAG"])
    TeamAwayGoalsConceeded[i]<- sum(serieA_2122[serieA_2122$AwayTeam==teams_list[i],"FTHG"])
}
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# (1) GOAL SCORED
#-------------------------------------------------------------------------------
# Dataframe for ggplot
goalscored_df <- data.frame(Stadium=rep(c("Home", "Away"),each=20),
                            Teams=rep(teams_list,2),
                            Goals=c(TeamHomeGoalsScored,TeamAwayGoalsScored)
                            )
# Plot
ggplot(goalscored_df, aes(x=Teams, y=Goals, fill=Stadium)) + 
    geom_bar(stat="identity", width=0.6, position=position_dodge(),colour="black")+
    scale_fill_manual(values = c("#145A32", "#52BE80"))+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1,face="bold"))+
    ggtitle("Goal scored Serie A 2021-22") +
    theme(plot.title = element_text(hjust = 0.5,face="bold"))

#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# (2) GOAL CONCEEDED
#-------------------------------------------------------------------------------
# Dataframe
goalconceeded_df <- data.frame(Stadium=rep(c("Home", "Away"),each=20),
                               Teams=rep(teams_list,2),
                               Goals=c(TeamHomeGoalsConceeded,TeamAwayGoalsConceeded)
                              )
# Plot
ggplot(goalconceeded_df, aes(x=Teams, y=Goals, fill=Stadium)) + 
    geom_bar(stat="identity", width=0.6, position=position_dodge(),colour="black")+
    scale_fill_manual( values=c("#641E16", "#EC7063"))+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1,face="bold"))+
    ggtitle("Goal conceeded Serie A 2021-22") +
    theme(plot.title = element_text(hjust = 0.5,face="bold"))
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# (3) GOAL SCORED/CONCEEDED DIFFERENCE HOME VS AWAY
#-------------------------------------------------------------------------------
# Dataframes
goal_scored_difference<- TeamHomeGoalsScored- TeamAwayGoalsScored
goal_conceeded_difference<- TeamHomeGoalsConceeded- TeamAwayGoalsConceeded

goal_scored_difference_df <- data.frame(teams_list,
                                        goal_scored_difference
                                        )

goal_conceeded_difference_df <- data.frame(teams_list,
                                           goal_conceeded_difference
                                           )
# Variable to color bars (green= GOOD ; red= BAD)
goal_scored_difference_df$color <- ifelse(goal_scored_difference_df$goal_scored_difference >= 0, 
                                           "#52BE80", "#EC7063")
goal_conceeded_difference_df$color <- ifelse(goal_conceeded_difference_df$goal_conceeded_difference >= 0, 
                                              "#EC7063", "#52BE80")

# Plots
ggplot(goal_scored_difference_df, aes(x = teams_list, 
                                      y = goal_scored_difference,
                                      fill = color)) +
    geom_bar(stat = "identity", width=0.6, position=position_dodge(),colour="black") +
    scale_fill_identity() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1,face="bold"))+
    labs(title = "Goal scored difference Home vs Away",
         x = "", 
         y = "Goal scored difference")+
    theme(plot.title = element_text(hjust = 0.5,face="bold"))

# Goal conceeded difference Home vs Away
ggplot(goal_conceeded_difference_df, aes(x = teams_list,
                                         y = goal_conceeded_difference,
                                         fill = color)) +
    geom_bar(stat = "identity", width=0.6, position=position_dodge(),colour="black") +
    scale_fill_identity() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1,face="bold"))+
    labs(title = "Goal conceeded difference Home vs Away",
         x = "", 
         y = "Goal conceeded difference")+
    theme(plot.title = element_text(hjust = 0.5,face="bold"))
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# (4) USEFUL RESULTS
#-------------------------------------------------------------------------------
serieA_2122$useful<-  (serieA_2122$FTR=="H") | (serieA_2122$FTR=="D")
useful_results_home<- vector(mode="numeric", length=length(teams_list))
useful_results_away<- vector(mode="numeric", length=length(teams_list))

for (i in 1:length(teams_list)){
    useful_results_home[i]<- sum(serieA_2122[serieA_2122$HomeTeam== teams_list[i],"useful"])
    useful_results_away[i]<- sum(!serieA_2122[serieA_2122$AwayTeam== teams_list[i],"useful"])
}

# Useful results home and away
useful_results_df <- data.frame(Stadium=rep(c("Home", "Away"),each=20),
                                Teams=rep(teams_list,2),
                                Result=c(useful_results_home,useful_results_away)
                                )

ggplot(useful_results_df, aes(x=Teams, y=Result, fill=Stadium)) + 
    geom_bar(stat="identity", width=0.6, position=position_dodge(),colour="black")+
    scale_fill_manual(values = c("#EC7063", "#52BE80"))+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1,face="bold"))+
    ggtitle("Useful results Serie A 2021-22") +
    theme(plot.title = element_text(hjust = 0.5,face="bold"))


# Useful results difference home vs away

# Dataframe
useful_result_difference<- useful_results_home- useful_results_away
useful_result_difference_df <- data.frame(teams_list,
                                          useful_result_difference
                                          )
useful_result_difference_df$Better<- ifelse(useful_result_difference_df$useful_result_difference > 0, 
                                            "Home", "Away")

# Plot
ggplot(useful_result_difference_df, aes(x = teams_list,
                                        y = useful_result_difference, 
                                        fill = Better)) +
    geom_bar(stat = "identity", width=0.6, position=position_dodge(),colour="black") +
    scale_fill_manual(values = c("#EC7063", "#52BE80"))+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1,face="bold"))+
    labs(title = "Useful result difference Home vs Away",
         x = "", 
         y = "Useful result difference")+
    theme(plot.title = element_text(hjust = 0.5,face="bold"))
#-------------------------------------------------------------------------------