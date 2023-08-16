#_______________________________________________________________________________
#   About: this function receives as inputs a correlation matrix
#          and return a plot representing that matrix
#_______________________________________________________________________________

plot_confusionmatrix<- function(confusionmatrix, modelname){
    # Convert confusion matrix into df
    df<- data.frame(confusionmatrix$`Confusion Matrix`[[1]])
    plot<-ggplot(df, aes(x = Target, y = Prediction, fill = N)) +
        geom_tile(color="black",lwd=0.4)+
        geom_text(aes(label = N), color = "black", size = 4)+
        xlab("Actual values")+
        ylab("Predicted values ")+
        ggtitle(modelname)+
        scale_fill_gradient(low = "white", high = "#0EBAC8")+
        theme(plot.title = element_text(hjust = 0.5,face="bold"),
              axis.text=element_text(size=12, face="bold"),
              axis.title=element_text(size=11),
              legend.position = "none")
    return(plot)
}
