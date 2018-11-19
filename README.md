# Causal climatic factors of malaria at the southern incidence fringe in the Americas

Code and data for the paper "Causal climatic factors of malaria at the southern incidence fringe in the Americas", by Karina Laneri, Brenno Cabella, Paulo Inácio Prado, Renato Mendes Coutinho, and Roberto André Kraenkel, submitted to PLoS One.

## Expected number of cases
We fit an inhomogeneous zero-inflated Poisson dynamics in discrete time to the number of cases recorded. See the [full explanation](count_models/poisson_models_tartagal.md), along with the code.

## CCM analysis
We ran causality tests for each of the climatic variables against the expected number of cases, as [shown here](CCM/CCM_tests.md). The significant ones were further analyzed to determine the signal and direction of the effect, as explained [here](CCM/multivariate.md).

