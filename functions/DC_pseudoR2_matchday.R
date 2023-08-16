#_______________________________________________________________________________         
# About: This function is applied over all the validation matchdays
#        It returns a kind of term of the "Pseudo-R2 prod" corresponding
#        to the current matchday. The idea is to take the probabilities associated
#        to the real result and multiply them all together
#_______________________________________________________________________________ 

DC_pseudoR2_matchday<-function(test,current_par){
    
    # Column of "pseudoR2"
    test$R2=rep(1,nrow(test))
    # Full time result possible determinations
    possible_FTR= c("H","D","A")
    
    for (m in 1:nrow(test)){
        # Get match teams
        teamA<- test[m,"HomeTeam"]
        teamB<- test[m,"AwayTeam"]
        # Get the real result of the match
        real_result<- test[m,"FTR"]
        # Get probabilities H-D-A 
        probs<- DC_HDA_probabilities(teamA,teamB,current_par) #
        # Select the probability associated to real FTR
        # step 1: index of FTR
        index_realFTR<- which(possible_FTR==real_result)
        # step 2: select the probability corresponding to that index
        test[m,"R2"]<-  probs[index_realFTR]
    }
    return(prod(test$R2))
}