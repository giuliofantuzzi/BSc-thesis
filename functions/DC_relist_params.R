#_______________________________________________________________________________         
#   About: a function to ensure Dixon&Coles sum-to-zero constraints
#          library(dplyr) is required!
#_______________________________________________________________________________  

DC_relist_params <- function(parameters) {
    parameter_list <- list(
        # att = attack rating
        att = parameters %>%
            .[grepl("att", names(.))] %>%
            append(prod(sum(.), -1), .) %>%  # Attack sum-to-zero constraint
            `names<-`(teams),
        # def = defence rating
        def = parameters %>%
            .[grepl("def", names(.))] %>%
            append(prod(sum(.), -1), .) %>%  # Defence sum-to-zero constraint
            `names<-`(teams),
        # home = home field advantage
        home = parameters["home"],
        # rho = dependence parameter 
        rho = parameters["rho"]
    )
    return(parameter_list)
}
