# Dataset
The dataset used for this project is available at the following link: https://www.football-data.co.uk/italym.php

It refers to the 2021-2022 edition of Serie A championship, and contains informations about all the matches (380) of the season. 
Attributes were originally 105, but the vast majority of them was not necessary for the purpose of my project (lots of them were odds from different bookmakers).
Before starting any type of analysis of data, I decided to select only the useful attributes from the dataset.

The `feature_selection.R` script, as its name suggests, deals with a data preparation phase for feature selection. Through this preliminary step, the original
dataset was converted into a new file ( `serieA_21-22.csv` ) containing all the variables needed to implement our goal-based models.

The table below shows all those variables:

<div align="center">
    
  Variable      | Type   | Description                                                               |
  ------------- |------- | ----------------------------------------------------------------------------
  **Date**      | _chr_  | The date when the match was played (format *gg/mm/yyyy*)                   |
  **HomeTeam**  | _chr_  | The team who plays the match on its own stadium                            |
  **AwayTeam**  | _chr_  | The visiting team who plays the match away                                 |
  **FTHG**      | _int_  | Goals scored by home team at the end of the match (*Full Time Home Goals*) |
  **FTAG**      | _int_  | Goals scored by away team at the end of the match (*Full Time Away Goals*) |                                   
  **FTR**       | _chr_  | Full time result (as *H-D-A*)                                              |

</div>

To import the dataset, we can use the R function *read.csv()* :
```r
>> serieA_2122<- read.csv("path/to/file/serieA_21-22.csv")
```
Then, there are at least two ways to accede a particular attribute. For example:

```r
>> serieA_2122[,"FTHG"]

>> serieA_2122$FTHG
```
