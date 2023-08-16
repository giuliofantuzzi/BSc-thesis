#_______________________________________________________________________________         
# About: This function is applied over all the validation matchdays
#        It returns the term of the "Brier-score sum" corresponding
#        to the current matchday
#_______________________________________________________________________________  

Maher_brier_score_matchday<-function(test,current_par){
    
    # Real result dummies
    test$deltaH= rep(0,nrow(test))
    test$deltaD= rep(0,nrow(test))
    test$deltaA= rep(0,nrow(test))
    
    # Terms of bs
    test$bs=rep(0,nrow(test))
    
    for (m in 1:nrow(test)){
        # Get match teams
        teamH= test[m,"HomeTeam"]
        teamA= test[m,"AwayTeam"]
        # Get probabilities H-D-A 
        probs=Maher_HDA_probabilities(teamH,teamA,current_par)
        # Get the real result
        real_result= test[m,"FTR"]
        # Given the real result, update Real result dummies (deltaH,deltaD,deltaA)
        test[m,paste("delta",real_result,sep="")]=1
        # Current row term of brier score
        test[m,"bs"] = sum((probs - as.numeric(test[m,c("deltaH","deltaD","deltaA")]))^2)
    }
    
    return(sum(test$bs))
}
