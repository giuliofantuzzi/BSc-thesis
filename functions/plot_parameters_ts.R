#_______________________________________________________________________________         
#   About: ~ This function receives a team name as input and returns a plot
#            that shows the team's abilities over the second half of the league
#          ~ Attack strength represented in blue
#          ~ Defence weakness represented in red
#_______________________________________________________________________________  

plot_parameters_ts<- function(team){
    #---------------------------------------------------------------------------
    # Get team abilities
    team_att<-vector(mode="numeric",length=19)
    team_def<-vector(mode="numeric",length=19)
    #---------------------------------------------------------------------------
    for (match in 20:38){
        #.......................................................................
        # Load parameters estimated for the current matchday
        filepath<- paste("parameters/DC_dinamic_parameters/par_list_",match,".RData",sep="")
        load(filepath)
        #.......................................................................
        # Select parameters associated to the best xi (from profile loglike)
        # Optimal parameters are in range 21:24 (-->xi=0.005) of par_list
        best_xi_par<-par_list[21:24] 
        #.......................................................................
        # Insert parameters into abiliy arrays
        i<-match-19
        team_att[i]<- as.numeric(best_xi_par$att[team])
        team_def[i]<- as.numeric(best_xi_par$def[team])
        #.......................................................................
    }
    #---------------------------------------------------------------------------
    # Create a dataframe of team abilities
    team_df<- data.frame(cbind(matchday=19:37,team_att,team_def))
    #---------------------------------------------------------------------------
    # Abilities over time plot
    plot_abilities<- ggplot(data = team_df, aes(x = matchday)) +
        geom_line(aes(y = team_att,colour="#154360"))+
        geom_point(aes(y = team_att, colour = "#154360"),
                   size = 2)+
        geom_line(aes(y = team_def,colour="#BB1B0B"))+
        geom_point(aes(y = team_def,colour = "#BB1B0B"),
                   size = 2)+
        xlab("Matchday")+
        ylab("Coefficients")+
        ggtitle(paste(team,"abilities over time",sep=" "))+
        scale_color_manual(name="Cofficient Type",
                           labels=c("Attack Strength", "Defence Weakness"),
                           values=c("#154360","#BB1B0B"))+
        theme(plot.title = element_text(hjust = 0.5,face="bold"),
              axis.text=element_text(size=10),
              axis.title=element_text(size=10,face="bold"))
    #---------------------------------------------------------------------------
    # Return the plot
    return(plot_abilities)
}
