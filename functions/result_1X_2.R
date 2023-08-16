#_______________________________________________________________________________
#   About: this function receives as input a vector of H-D-A probabilities
#          and returns a string corresponding to the most probable event between:
#           -1X: HomeTeam doesn't lose the match
#           -1 : HomeTeam loses the match
#_______________________________________________________________________________

result_1X_2<- function(probs){ #probs vettore di probabilità H,D,A
    Pr_1X= probs[1]+probs[2]
    Pr_2= probs[3]
    if(Pr_1X>Pr_2){
        return("1X")
    }
    else{return("2")}
}