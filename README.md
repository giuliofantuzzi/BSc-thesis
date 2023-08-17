# Statistical modelling for predicting football outcomes: an R implementation of the Dixon-Coles model and applications to the 2021-2022 serie A championship 

This repository contains an R implementation of my BSc thesis in Statistics (University of Trieste)
## Short abstract
Football is undoubtedly one of the most beloved sports globally, and statistical analysis to understand the dynamics of the game and predict its outcomes is becoming increasingly important. The main objective of my thesis project is to evaluate the effectiveness of goal-based statistical models, which aim to predict the number of goals scored by the two teams competing in a football match.

Firstly, we will seek to identify a suitable probability distribution to describe the number of goals scored. Subsequently, we will delve into the key model propositions available in the scientific literature. We will begin by examining the model introduced by Maher, analyzing its strengths and limitations to comprehend the pivotal aspects to be included in the statistical modeling of soccer outcomes. Among these aspects, we will explore the consideration of team-specific attacking and defensive strengths, the influence of playing at home (home effect), and the impact of teams' current form (both physical and psychological) on their performances. All this will lead to the Dixon and Coles model, one of the most renowned and widely used goal-based models in the world of sports statistics. The analyzed models were then implemented using *R software*, adopting a *from scratch* approach. Leveraging historical [data](data/) from the 2021-2022 Serie A championship, the thesis will delve into specific applications of the model, even extending beyond the mere prediction of match outcomes.

In summary, this thesis project aims to provide a comprehensive overview of goal-based models and to enhance their understanding through empirical applications to the 2021-2022 Serie A championship, thereby offering empirical evidence of their effectiveness.




## R scripts
Some brief information about the R scripts contained in this repository (more details in the scripts' headers)

### Preliminary analysis
- `poisson_approximation.R` : analysis of Poisson as an approximation for Teams's Goals
- `home_effect.R` : an empirical proof of a home effect in football

### Parameters estimation
- `Maher_parameters_estimation.R` : estimation of Maher model's optimal parameters (using all season matches as training-set)
- `DC_static_parameters_estimation.R` : estimation of Dixon-Coles static model's optimal parameters (using all season matches as training-set)
- `DC_dinamic_parameters_estimation.R` : estimation of Dixon-Coles dinamic model's optimal parameters (over the 2nd half of the season)
- `xi_profile_loglike.R` : estimation of the best value of $\xi$ (parameter of dinamic Dixon-Coles model) through a profile log-likelihood (PLL) approach

### Applications to the 2021-2022 Serie A championship
- `DC_predictions_matchday38.R` : predictions of Dixon-Coles (dinamic) model for the last matchday (38th)
- `abilities_over_time.R` : attack and defence abilities timeseries over the 2nd half of the league
- `home&rho_over_time.R` : timeseries of home effect and correlation coefficients over the 2nd half of the league

### Models comparison and evaluation
- `brier_score.R` : R implementation of *Brier Score* metric to compare models
- `pseudoR2.R` : R implementation of *Pseudo-*$R^2$ metric to compare models
- `confusion_matrices.R` : implementation of confusion matrices to analyze models' performances

As previously mentioned, all the analyzed models were implemented using a *from scratch* approach. This means that every function, from lower to higher level, was built starting from zero. For more details about these functions check the directory [functions](functions/). Models' optimal parameters, instead, can be found in the directory [parameters](parameters/).
