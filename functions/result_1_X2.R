#_______________________________________________________________________________
#   About: this function receives as input a vector of H-D-A probabilities
#          and returns a string corresponding to the most probable event between:
#           -X2: AwayTeam doesn't lose the match
#           -1 : AwayTeam loses the match
#_______________________________________________________________________________

result_1_X2<- function(probs){ #probs vettore di probabilità H,D,A
    Pr_1= probs[1]
    Pr_X2= probs[2]+probs[3]
    if(Pr_1>Pr_X2){
        return("1")
    }
    else{return("X2")}
}