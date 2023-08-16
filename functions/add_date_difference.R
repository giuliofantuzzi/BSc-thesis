#_______________________________________________________________________________         
#   About: This function receives as inputs training and test set
#          Then it calculates time-distances (in days) between
#          each match of the training and the last date in the test-set
#          Time differencies are added to the training set, which is returned
#_______________________________________________________________________________         

add_date_difference<- function(training,test= training) { #NB: default take all the dataset
    # 1) Extract match dates
    match_dates<- training[,"Date"]
    # 2) Convert into dates
    match_dates<- as.Date(match_dates, format= "%d/%m/%Y")
    # 3) Get the last date (nella giornata in cui faccio previsioni non giocano tutti lo stesso giorno...per convenzione prendo l'ultima)
    last_match_date<- as.Date(test[nrow(test),"Date"], format= "%d/%m/%Y")
    # 4) Calculate datediff
    date_diff<- as.numeric(difftime(last_match_date,match_dates, units="days"))
    # 5) Add datediff to dataframe
    training['DateDiff'] <- date_diff
    # 7) Return the new dataframe
    return(training)
}
