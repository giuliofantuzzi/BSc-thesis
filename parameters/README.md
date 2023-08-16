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
The parameters of Dixon-Coles static model follows the same *"named-list"* structure. Besides attack and defence parameters ($\alpha$ and $\beta$), this model considers a home effect parameter ($\gamma$) and 
a goal-correlation coefficien (\rho). Once estimated, we can accede the values as follows:
```r
>> DC_static_parameters$att
>> DC_static_parameters$def
>> DC_static_parameters$home
>> DC_static_parameters$rho
```
Notice that * DC_static_parameters$att* and * DC_static_parameters$att* are named arrays of length *n*, while *DC_static_parameters$home* and *C_static_parameters$rho* are single (named) values.

## Dixon-Coles dinamic model
