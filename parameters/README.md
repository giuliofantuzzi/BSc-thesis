# Models' parameters
Optimal parameters have been determined using maximum likelihood estimation (MLE). Since the estimation phase may take long I decided to store models' parameters as `.RData` files, so that it will be easy to import our parameters any time 
without estimating them again.
```r
>> load("path/to/file/file.RData")
```

## Maher model
Maher's model describes each team $i$ with a coefficient for attack strength ( $\alpha_i$ ) and a coefficient for defence weakness ( $\beta_i$ ).
Given a league of $n$ teams, the parameters to estimate are $\left(\alpha_1,...,\alpha_n, \beta_1, ..., \beta_n \right\)$, so $2n$ parameters in total.

Instead of using arrays, I decided to organize my parameters in a "named-list" structure. With *"named-list"* I mean that my object *Maher_parameters* will have 2 attributes: *att* and *def* (Attack and Defence). To accede them:
```r
>> Maher_parameters$att
>> Maher_parameters$def
```
Then, both *Maher_parameters$att* and *Maher_parameters$def* will be named arrays, where teams' names are associated to their corresponding coefficients. This will make very simple to accede the values, because instead of
using indexes it will be possible to use names.

For example:
```r
>> Maher_parameters$att['Milan']
>> Maher_parameters$def['Roma']
```
## Dixon-Coles static model
The parameters of Dixon-Coles static model follow the same *"named-list"* structure. Besides attack and defence parameters ($\alpha$ and $\beta$), this model considers a home effect parameter ($\gamma$) and 
a goal-correlation coefficien (\rho). Once estimated, we can accede the values as follows:
```r
>> DC_static_parameters$att
>> DC_static_parameters$def
>> DC_static_parameters$home
>> DC_static_parameters$rho
```
Notice that * DC_static_parameters$att* and * DC_static_parameters$att* are named arrays of length *n*, while *DC_static_parameters$home* and *DC_static_parameters$rho* are single (named) values.

## Dixon-Coles dinamic model
The parameters of Dixon-Coles dinamic model follow a more complex structure. Since these parameters are dinamic, they were estimated in association to each matchday over the 2nd half of the league. In addition to that, this model considers a time-decay parameter $\xi$. Its estimation requires a different approach (see [xi_profile_loglike.R](../xi_profile_loglike.R)):  parameters $\alpha,\beta,\gamma,\rho$, besides being associated to a particular matchday, are also associated to a particular value of $\xi$. For this reason, it was convenient to proceed as follows:

- iterate over the different matchdays;
- in each iteration, iterate over the different values of $\xi$;
- For a given matchday and a fixed value of $\xi$, estimate the optimal parameters using MLE;

This implementation has an impact on the structure of our parameters. In particular, the directory [DC_dinamic_parameters](DC_dinamic_parameters/) contains a `.RData` file for each matchday (2nd half of the league). Let's consider one of those files, i.e. `par_list_38.RData`. The name of the file indicates that its parameters were estimated to predict matchday n.38, using as training set all the matchdays from 1 to 37 (it's pretty easy to adapt this logic to all the other files).

We can import the parameters as follows:
```r
>> load("path/to/file/par_list_38.RData")
```
By doing that, an object called *par_list* will be imported. We can think about it like a "big array", where lots of *"named-lists"* (like the ones of Dixon-Coles static model ) are concatenated side by side. More precisely, these lists refer to the corresponding values of $\xi$, and we can isolate them applying some indexes to the object *par_list* (remember that *"named-lists"* have length=4). For example:
```r
# To accede the parameters associated to the first value of xi
>> par_list_38[1:4]
# To accede the parameters associated to the second value of xi
>> par_list_38[5:8]
# And so on....
```
**NOTE FOR THE USER:** 

For my analysis I decide to implement the Profile log-likelihood (PLL) using a small interval of $\xi$ values (basing on the pre-existing result from Dixon and Coles):
```r
>> xi_values<- seq(from=0, to=0.01, by = 0.001)
```
<ins>In my particular case</ins>, *xi_values* was an array of length 11, so the corresponding indexes were [1:4 ; 5:8 ; ... ; 41:44]

Accoding to my PLL's result,  the optimal value of $\xi$ was $\xi=0.005$, so its corresponding indexes were [21:24]
