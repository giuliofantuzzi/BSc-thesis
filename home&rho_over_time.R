#_______________________________________________________________________________
# About: Home effect and Rho coefficients over the second half of the league
#_______________________________________________________________________________

#-------------------------------------------------------------------------------
# Empty arrays for parameters timeseries
home_ts<- vector(mode="numeric", length=19)
rho_ts<- vector(mode="numeric", length=19)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Iteration over the 2nd half of the league to get values
for (match in 20:38){
    #.................................................................
    # Load parameters estimated for the current matchday
    filepath<- paste("parameters/eps/par_list_",match,".RData",sep="")
    load(filepath)
    #.................................................................
    # Select parameters associated to the best value of xi (0.005)
    best_eps_par<-par_list[21:24]
    #.................................................................
    # Insert Home and Rho coefficients into arrays
    i<-match-19
    home_ts[i]<- best_eps_par$home
    rho_ts[i]<- best_eps_par$rho
    #.................................................................
}
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Create dataframes for ggplot
matchday<- 19:37
home_ts_df= data.frame(cbind(matchday,home_ts))
rho_ts_df= data.frame(cbind(matchday,rho_ts))
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
library(ggplot2)

home_ts_plot<- ggplot(data = home_ts_df,aes(x=matchday,y = home_ts)) +
    geom_line(colour="#D35400",size=0.7)+
    geom_point(shape = 21, colour = "#D35400", fill="#F5CBA7",size = 1.5, stroke=1)+
    xlim(19,37)+
    ylim(0,0.5)+
    xlab("Matchday")+
    ylab(expression("Home effect"~(gamma)))+
    ggtitle("Home effect over time")+
    theme(plot.title = element_text(hjust = 0.5,face="bold"))

rho_ts_plot<- ggplot(data = rho_ts_df,aes(x=matchday,y = rho_ts)) +
    geom_line(colour="#0A4079",size=0.7)+
    geom_point(shape = 21, colour = "#0A4079", fill="#F5CBA7",size = 1.5, stroke=1)+
    xlim(19,37)+
    ylim(0,-0.5)+
    xlab("Matchday")+
    ylab(expression("Dependence effect"~(rho)))+
    ggtitle("Dependence effect over time")+
    theme(plot.title = element_text(hjust = 0.5,face="bold"))
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Timeseries plots
home_ts_plot
rho_ts_plot
#-------------------------------------------------------------------------------