#_______________________________________________________________________________         
#   About: this function creates dummies for both home and away teams
#          and add them to the dataframe.
#_______________________________________________________________________________         

team_dummies<- function(data) {
    # 1) Get teams name (for this purpose considering Home or Away is the same!)
    teams_list<- names(table(data[,"HomeTeam"]))
    # 2) Get nrows of the dataframe
    n_rows<- dim(data)[1]
    # 4) Arrays of Home/Away teams
    HomeTeams<-  data[,"HomeTeam"]
    AwayTeams<-  data[,"AwayTeam"]
    # 5) Get dummies 
    HomeDummies<- vector(mode="numeric", length= n_rows)
    AwayDummies<- vector(mode="numeric", length= n_rows)
    for (i in 1:n_rows){ #passo TUTTO il df
        HomeDummies[i] = which(teams_list==HomeTeams[i])
        AwayDummies[i] = which(teams_list==AwayTeams[i])
    }
    # 6) Add dummies to dataframe
    data['HomeDummy'] <- HomeDummies
    data['AwayDummy'] <- AwayDummies
    # 7) Return the new dataframe
    return(data)
}
