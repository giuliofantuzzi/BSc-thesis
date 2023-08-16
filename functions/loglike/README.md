# Log-likelihood functions
Optimal parameters have been determined using maximum likelihood estimation (MLE). Since probabilities can be very small and may lead to numerical underflow, it's common to work with the logarithm of the likelihood function, 
known as log-likelihood. Taking the logarithm often simplifies calculations and doesn't affect the location of the maximum (it is a monotonic increasing function). For simplicity I decided to build the log-likelihood functions, 
and since the R function *optim()* is meant to minimze a function (and not to maximize it), I based the implementation on the following proposition:
$$x = argmax f(x) \Longleftrightarrow x= argmin(-f(x))$$

1) **Maher log-likelihood**
$$l(\alpha_i,\beta_i, i=1,...n) = \sum_{k=1}^N {\log\left(\frac{(\lambda_k)^{x_k}}{x_k!} e^{-\lambda_k}\right) + \log\left( \frac{(\mu_k)^{y_k}}{y_k!} e^{-\mu_k}\right)}$$

2) **Static Dixon-Coles log-likelihood**
$$l(\alpha_i,\beta_i,\gamma,\rho, i=1,...n) = \sum_{k=1}^N {\log[\tau_{\lambda_{k},\mu_{k}}(x_k,y_k)] + \log\left[ \frac{(\lambda_k)^{x_k}}{x_k!} e^{-\lambda_k}\right] + \log\left[\frac{(\mu_k)^{y_k}}{y_k!} e^{-\mu_k}\right]}$$

3) **Dinamic Dixon-Coles log-likelihood**
$$l(\alpha_i,\beta_i,\gamma,\rho) = \sum_{k \in A_t}{e^{-\xi (t-t_k)} \left[\log[\tau_{\lambda_{k},\mu_{k}}(x_k,y_k) ] +\log \left(\frac{(\lambda_k)^{x_k}}{x_k!} e^{-\lambda_k}\right) + \log \left(\frac{(\mu_k)^{y_k}}{y_k!} e^{-\mu_k}\right)\right]}$$
