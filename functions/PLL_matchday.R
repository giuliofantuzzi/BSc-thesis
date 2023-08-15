#_______________________________________________________________________________         
#   About: this function returns the PLL associated to a single matchday [Sm(xi)]
#          For each validation matchday m, we calculate a partial PLL [Sm(xi)]
#          and then we sum them all together to get a unique measure of S(xi)
#_______________________________________________________________________________  

PLL_matchday<- function(test,current_par){
    # Real result dummies
    test$deltaH= rep(0,nrow(test))
    test$deltaD= rep(0,nrow(test))
    test$deltaA= rep(0,nrow(test))
    # Terms of s(eps)
    test$s_eps=rep(0,nrow(test))
    
    for (m in 1:nrow(test)){
        # Get match teams
        teamA= test[m,"HomeTeam"]
        teamB= test[m,"AwayTeam"]
        # Get probabilities H-D-A 
        probs=DC_HDA_probabilities(teamA,teamB,current_par)
        # Get the real result
        real_result= test[m,"FTR"]
        # Given the real result, update Real result dummies (deltaH,deltaD,deltaA)
        test[m,paste("delta",real_result,sep="")]=1
        #current row term of s(eps) [remember to use log probabilities]
        test[m,"s_eps"] = log(probs)%*%as.numeric(test[m,c("deltaH","deltaD","deltaA")])
    }
    return(sum(test$s_eps))
}






#-------------------------------------------------------------------------------

