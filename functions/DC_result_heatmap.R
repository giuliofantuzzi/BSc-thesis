#_______________________________________________________________________________         
#   About: function that receives the name of the teams and
#          returns a result heatmap, where each possible result is associated
#          to his probability (given by Dixon-Coles dinamic model)
#          NB: we assume 4 is the max n.of goals for each team!
#_______________________________________________________________________________         

DC_result_heatmap<- function(teamH,teamA, parametri){
    # Goal combinations
    goalH <- goalA <- 0:4
    df <- expand.grid(goalH=goalH, goalA=goalA)
    # Conj Probabilities
    for (k in 1:nrow(df)){
        df$Probability[k] <- DC_joint_probability(df$goalH[k], df$goalA[k], teamH, teamA, parametri)
    }
    # Plot
    match_heatmap<- ggplot(df, aes(x=goalA, y=goalH, fill=Probability)) + 
        geom_tile(color="black") +
        scale_fill_gradient(low="white", high="red3") +
        labs(x=paste("Goals",teamA), y=paste("Goals",teamH))+
        geom_text(aes(label = round(Probability, 3)), color = "black", size = 5)+
        labs(title=paste("Match: ",teamH,"-",teamA))+
        theme_minimal()+
        theme(plot.title = element_text(hjust = 0.4,face="bold"),
              axis.title = element_text(size = 12, face="bold"),
              axis.text = element_text(size = 12))
    return(match_heatmap)
}
