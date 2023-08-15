#_______________________________________________________________________________         
#   About: ~ Given 2 teams playing a match, this function returns aggregate
#            probabilities of the type Home - Draw - Away
#          ~ Different combinations of results are arranged in a df and then
#            the function DC_joint_probability() is applied to each row
#            Then these probabilities are aggregated to obtain a HDA measure
#_______________________________________________________________________________ 

DC_HDA_probabilities<- function(teamH,teamA, parametri){
    x <- y <- 0:4
    df <- expand.grid(x=x, y=y)
    for (k in 1:nrow(df)){
        df$Probability[k] <- DC_joint_probability(df$x[k], df$y[k], teamH, teamA, parametri)
    }
    home= sum(df[df$x>df$y,"Probability"])
    draw= sum(df[df$x==df$y,"Probability"])
    away= sum(df[df$x<df$y,"Probability"])
    return (c(home,draw,away))
}

