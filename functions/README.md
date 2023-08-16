# Functions
The estimation of models' optimal parameters is based on the optimization of a log-likelihood function. Check [loglike](loglike/) for more details.

All the functions above were built starting from zero. Some of them are very general, while others refer to a specific model.

### General functions
- `add_date_difference.R` : function that receives as inputs training and test set, and then calculates time-distances (in days) between each match of the training and the last date in the test-set. Time differencies are added to the training set, which is returned by the function

- `plot_confusionmatrix.R` : function that receives as inputs a correlation matrix and return it as a plot

- `plot_parameters_ts.R` function that receives a team name as input and returns a plot showing the team's abilities over the second half of the league. Attack strength will be represented in blue, while defence weakness will be represented in red

- `result_HDA.R` : function that receives as input a numerical vector of *Home-Draw-Away* probabilities and returns the string ("H","D" or "A") of the most probable result

- `result_1X_2.R` : function that receives as input a vector of H-D-A probabilities and returns a string corresponding to the most probable event between *1X* (home team doesn't lose) and *2* (it loses)

- `result_1_X2.R` : function that receives as input a vector of H-D-A probabilities and returns a string corresponding to the most probable event between *X2* (away team doesn't lose) and *1* (it loses)

- `PLL_matchday.R` : function that returns the profile-loglike PLL [ $`S_m (\xi) `$ ] associated to a single matchday ($m$).  By iteration we can calculate all the partial PLLs [ $`S_m (\xi) `$ ] and sum them all together to get a unique measure $`S(\xi)= \sum\limits_{m}{S_m (\xi)}`$

### Maher model functions

- `Maher_joint_probability.R` : this function receives the following parameters:  home goals ($x$),away goals ($y$), team names and Maher coefficients. Then, it returns the joint probability of getting the result $(x,y)$

- `Maher_HDA_probabilities.R` : given 2 teams playing a match (and Maher model parameters), this function returns aggregate probabilities of the type *Home-Draw-Away*

- `Maher_brier_score_matchday` : this function is applied to a single matchday and returns the term of the "Brier-score sum" corresponding to that matchday. The idea is to apply it by iteration on a set of validation matchdays and then obtain the overall Brier Score of the model

- `Maher_pseudoR2_matchday` : this function is applied to a single matchday and returns s a kind of term of the "Pseudo-$R^2$ prod". The idea is to apply it by iteration on a set of validation matchdays and obtain the overall *Pseudo-*$R^2$ of the model

- `Maher_relist_params.R` : this function is useful for the optimization phase to estimate model's parameters, since their structure is named-list like (see `../parameters/` folder). More precisely, the R function *optim()* doesn't support the class *list* for its argument *par* (the initial guess of the optimization algorithm). The problem was easily solvable by passing the argument through *unlist()*, and then re-listing it (inside the loglike function) thanks to our *Maher_relist_params()*. In summary, this function allows us to preserve the named-list structure of the parameters.

### Dixon-Coles model functions

- `DC_joint_probability.R` : this function receives the following parameters:  home goals ($x$),away goals ($y$), team names and Dixon-Coles parameters. Then, it returns the joint probability of getting the result $(x,y)$. Notice that the order of the teams' name is important!

- `DC_HDA_probabilities.R` : given 2 teams playing a match (and Dixon-Coles model parameters), this function returns aggregate probabilities of the type *Home-Draw-Away*. As before, notice that the order of the teams' name is important!

- `DC_brier_score_matchday.R` : this function is applied to a single matchday and returns the term of the "Brier-score sum" corresponding to that matchday. The general idea is the same as seen above for Maher's model

- `DC_pseudoR2_matchday` : this function is applied to a single matchday and returns s a kind of term of the "Pseudo-$R^2$ prod". The general idea is the same as seen above for Maher's model

- `DC_relist_params.R` : as seen for Maher's model, this function is useful for the optimization phase, in order to preserve the named-list structure of the parameters. Differently from `Maher_relist_params.R` , the function `DC_relist_params.R` allows to ensure sum-to-zero costraints for attack and defence parameters

- `DC_tau.R` : implementation of the $\tau$ function, which is a factor of the Dixon-Coles log-likelihood

- `DC_result_heatmap.R` : function that receives the name of the teams (the order is important!) and returns a result heatmap, where each possible result is associated  to his probability (given by Dixon-Coles best dinamic model)
