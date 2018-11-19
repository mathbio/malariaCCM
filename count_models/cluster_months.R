## Monthly data, Tartagal
library(zoo); library(xts)
library(rjags); library(R2jags)

## ----data reading--------------------------------------------------------
ncases <- read.csv("../data/DataMalariaTartagalCCM.csv")
ncases$date <- as.Date(ncases$date, "%d/%m/%Y")
summary(ncases)
ncasesz <- zoo(ncases[,-1], ncases[,1])

## ----Poisson model, eval=FALSE-------------------------------------------

## N de sites e ocasioes
totcasos <- ncases$cases
nIntervals <- length(totcasos)

## Lista com dados
data.list <- list(nIntervals=nIntervals, y=totcasos)
## Valores iniciais baseados nos casos observados:
## Tive que usar valores fixos e baseados nos dados pq alternativas (comentadas)
## dao o famoso erro "Node inconsistent with parents"
inits <- function() list(
                        N = ceiling(totcasos*1/0.9+0.01),
                        r = log((totcasos[-(length(totcasos))]+0.01)/(totcasos[-1]+0.01)),
                        lp = log(0.9/0.1)
                    )

## Parametros a acompanhar
pars <- c("N", "mu", "ypred", "p", "r")
## Parallel
fit1 <- jags.parallel(data = data.list,
                      inits= inits,
                      parameters.to.save = pars,
                      model.file = "poisson_model.jag",
                      n.iter = 1e6,
#                      n.burnin = 1.45e5,
                      n.chains=4,
                      export=c("totcasos", "nIntervals"))
save.image()
save(ncases, ncasesz, fit1, file="fit1.RData")
