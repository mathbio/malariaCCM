# A zero-inflated Poisson model for cases of Malaria in Tartagal
*author: Paulo Inácio Prado*

## Statistical model used

The idea is to fit an inhomogeneous zero-inflated Poisson dynamics in discrete time.
The expected size of the population of infected people is the single state variable,
which has a growth that can change at each time step. The number of infected people at
each time step follows a Poisson distribution where its single parameters is the expected number of cases.
The number of recorded cases is a proportion of the number of infected people.

This model thus describe the number of observed cases as a zero-inflated Poisson variable,
that evolve in time (that is , inhomogeneous in time). Our purpose with this model is
to provide a time series of expected number of cases with minimal assumptions. 
By replacing the original time series of observed cases with this estimated time series can have two main
advantages:

- Zero values are eliminated, as they are replaced by the expected numbers (the estimated time-varying parameter of the Poisson).
- Observation (including detection errors that can explain part of the zeroes) and part of prcess errors are sorted out.


### Model specification:

##### Number of infected people in the population: 

   * E[N(t+1)] =  N(t) exp(r(t))
   * N(t) ~ Poisson(lambda = E[N(t)])

##### Number of cases detected :

   * n(t) ~ Binomial(P(t), N(t))

##### Where:

* E[X] expected values
* r(t) a time-varying rate of change
* P is the proportion of detected cases


### Model script

The model is a discrete time dynamics, fitted by the a bayesian MCMC routine
using the [JAGS](http://www.uvm.edu/~bbeckage/Teaching/DataAnalysis/Manuals/manual.jags.pdf), language with the R packages
[rjags](https://cran.r-project.org/package=rjags) e [R2jags](https://cran.r-project.org/package=R2jags).

The model script in Jags is [here](poisson_model.jag). 


## Monthly data

* Number of Malaria cases in Tartagal, Salta, from 12/1999 to 
11/2011
* Time series length: 144 months
* Total number of cases: 266



<img src="figure/data reading-1.png" title="plot of chunk data reading" alt="plot of chunk data reading" style="display: block; margin: auto;" />

### Model settings



The model was fitted in parallel with a separated R script, because it is time-consuming.

* Number of chains: 4
* Number of iterations in each chain: 1000000
* Burn-in period (n iterations discarded): 500000
* Thinning period: 500
* Number of values of the posterior distribution kept in each interaction: 1000
* Total number of values of posterior kept: 4000


### Model Convergence

Convergence ok: 

* R-hat statistics of estimated posterior parameters ranged from 1.0005 
to 1.047
* Effective size of samples of posterior distributions ranged from 850 
to 850


### Estimated detection probability

The posterior mean detection probability is
0.158.

The plot of posterior density of the four chains pooled is above:

<img src="figure/posterior p detection-1.png" title="plot of chunk posterior p detection" alt="plot of chunk posterior p detection" style="display: block; margin: auto;" />


### Observed x predicted number of cases

The plot shows the expected value of the number of cases recorded and
its credible interval (blue) and the observed number of cases (red).

<img src="figure/plots-1.png" title="plot of chunk plots" alt="plot of chunk plots" style="display: block; margin: auto;" />

### Files

* [R script](cluster_months.R) (ran in a separate machine in parallel)
* [R binary file](fit1.RData) with the object of the fitted model (class rjags). 
* [Fitted expected number of cases](predicted_cases_poisson_model_monthly.csv): time series of the mean of posterior distributions. Comma-delimited (csv)


## Weekly data

* Same dataset, but aggregated by epidemiological week.
* Time series length: 624 weeks


<img src="figure/Weekly data reading-1.png" title="plot of chunk Weekly data reading" alt="plot of chunk Weekly data reading" style="display: block; margin: auto;" />


### Model settings



The model was fitted in parallel with a separated R script, because it is time-consuming.

* Number of chains: 4
* Number of iterations in each chain: 3000000
* Burn-in period (n iterations discarded): 1500000
* Thinning period: 1500
* Number of values of the posterior distribution kept in each interaction: 1000
* Total number of values of posterior kept: 4000


### Model Convergence

Convergence ok: 

* R-hat statistics of estimated posterior parameters ranged from 1.0005 
to 1.2877
* Effective size of samples of posterior distributions ranged from 560 
to 560

The posterior mean detection probability is
0.158.

### Estimated detection probability

The posterior mean detection probability is very low:
0.0112.

Because this detection is constant, I do not think it will affect
the smoothing of predicted number of cases itself, only teh magnitude of the predicted values.
So, I suppose that's ok to use in CCM, right?

The plot of posterior density of the four chains pooled is below.

<img src="figure/weekly posterior p detection-1.png" title="plot of chunk weekly posterior p detection" alt="plot of chunk weekly posterior p detection" style="display: block; margin: auto;" />


### Observed x predicted number of cases

The plot shows the expected value of the number of cases recorded and
its credible interval (blue) and the observed number of cases (red).

<img src="figure/Weekly plots-1.png" title="plot of chunk Weekly plots" alt="plot of chunk Weekly plots" style="display: block; margin: auto;" />

### Files

* [R script](cluster.R) (ran in a separate machine in parallel)
* [R binary file](fit2.RData) with the object of the fitted model (class rjags). 
* [Fitted expected number of cases](predicted_cases_poisson_model_weekly.csv): time series of the mean of posterior distributions. Comma-delimited (csv)

