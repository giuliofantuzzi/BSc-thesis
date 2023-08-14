#_______________________________________________________________________________         
#   About:   Analysis of Poisson as a good approximation for teams' goals
#_______________________________________________________________________________  

#-------------------------------------------------------------------------------
# Import data
serieA_2122<- read.csv("data/serieA_21-22.csv")
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# (1) EMPIRICAL VS POISSON: COMPARISON OF HOME GOALS PROBABILITIES
#-------------------------------------------------------------------------------

# Empirical probabilities  ()
ep0=round(sum(serieA_2122$FTHG==0)/380, digits=3)
ep1=round(sum(serieA_2122$FTHG==1)/380, digits=3)
ep2=round(sum(serieA_2122$FTHG==2)/380, digits=3)
ep3=round(sum(serieA_2122$FTHG==3)/380, digits=3)
ep4=round(sum(serieA_2122$FTHG==4)/380, digits=3)
ep5=round(sum(serieA_2122$FTHG==5)/380, digits=3)

# Poisson parameter (mean of home goals)
lambda= mean(serieA_2122$FTHG)

# Theoretical probabilities
tp0 =round(dpois(0,lambda), digits=3)
tp1 =round(dpois(1,lambda), digits=3)
tp2 =round(dpois(2,lambda), digits=3)
tp3 =round(dpois(3,lambda), digits=3)
tp4 =round(dpois(4,lambda), digits=3)
tp5 =round(dpois(5,lambda), digits=3)

# Plot
library(ggplot2)
pois_df<- data.frame(Goals= c(0,1,2,3,4,5,0,1,2,3,4,5),
                     Type=rep(c("Empirical", "Poisson"),each=6),
                     Probability=c(ep0,ep1,ep2,ep3,ep4,ep5,tp0,tp1,tp2,tp3,tp4,tp5))

ggplot(pois_df, aes(x=Goals, y=Probability, fill=Type)) + 
    geom_bar(stat="identity", width=0.6, position=position_dodge(),colour="black")+
    scale_x_continuous(breaks = round(seq(0, 5, by = 1)))+
    scale_fill_manual(values = c("#154360", "#5499C7"))+
    theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust=1,face="bold"))+
    ggtitle("Is poisson a good approximation?") +
    theme(plot.title = element_text(hjust = 0.5,face="bold"))
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
# (2) EMPIRICAL VS POISSON: COMPARISON OF HOME GOALS FREQUENCIES
#-------------------------------------------------------------------------------

# Empirical frequencies (ef)
ef0=sum(serieA_2122$FTHG==0)
ef1=sum(serieA_2122$FTHG==1)
ef2=sum(serieA_2122$FTHG==2)
ef3=sum(serieA_2122$FTHG==3)
ef4=sum(serieA_2122$FTHG==4)
ef5=sum(serieA_2122$FTHG==5)

# Poisson parameter (the same of the previous analysis)
lambda= mean(serieA_2122$FTHG)

# Theoretical frequences (tf)
tf0 =round(dpois(0,lambda)*380)
tf1 =round(dpois(1,lambda)*380)
tf2 =round(dpois(2,lambda)*380)
tf3 =round(dpois(3,lambda)*380)
tf4 =round(dpois(4,lambda)*380)
tf5 =round(dpois(5,lambda)*380)

library(ggplot2)
poisfreq_df<- data.frame(Goals= c(0,1,2,3,4,5,0,1,2,3,4,5),
                         Type=rep(c("Empirical", "Poisson"),each=6),
                         Frequency=c(ef0,ef1,ef2,ef3,ef4,ef5,tf0,tf1,tf2,tf3,tf4,tf5))

ggplot(poisfreq_df, aes(x=Goals, y=Frequency, fill=Type)) + 
    geom_bar(stat="identity", width=0.6, position=position_dodge(),colour="black")+
    scale_x_continuous(breaks = round(seq(0, 5, by = 1)))+
    scale_fill_manual(values = c("#154360", "#5499C7"))+
    theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust=1,face="bold"))+
    ggtitle("Poisson approximation of Home Goals frequency") +
    theme(plot.title = element_text(hjust = 0.5,face="bold"))
#-------------------------------------------------------------------------------