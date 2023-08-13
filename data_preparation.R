# Import raw data
serieA_2122<- read.csv("data/serieA_21-22_original_dataset.csv")

# Feature selection
serieA_2122<- serieA_2122[,c("Date","HomeTeam", "AwayTeam", "FTHG", "FTAG", "FTR")]

# Create team dummies
source("functions/team_dummies.R")
serieA_2122<- team_dummies(serieA_2122)

# Save the dataset
write.csv(serieA_2122, file="data/serieA_21-22.csv",row.names = FALSE)