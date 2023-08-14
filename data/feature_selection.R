# Import raw data
serieA_2122<- read.csv("serieA_21-22_original_dataset.csv")

# Feature selection
serieA_2122<- serieA_2122[,c("Date","HomeTeam", "AwayTeam", "FTHG", "FTAG", "FTR")]

# Save the dataset
write.csv(serieA_2122, file="serieA_21-22.csv",row.names = FALSE)
