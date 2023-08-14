Maher_relist_params <- function(parameters) {
    parameter_list <- list(
        # att = attack rating
        att = parameters %>%
            .[grepl("att", names(.))] %>%
            `names<-`(teams),
        # def = defence rating
        def = parameters %>%
            .[grepl("def", names(.))] %>%
            `names<-`(teams)
    )
    return(parameter_list)
}