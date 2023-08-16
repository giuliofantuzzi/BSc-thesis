#_______________________________________________________________________________
#   About: this function receives as input a vector of H-D-A probabilities
#          and returns a string corresponding to the most probable result
#_______________________________________________________________________________
result_HDA<- function(probs){
    max_index= which(probs==max(probs))
    if (max_index==1){return("H")}
    if (max_index==2){return("D")}
    if (max_index==3){return("A")}
}