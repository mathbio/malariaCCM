library(zoo); library(xts)
library(rjags); library(R2jags)

ncasesW <- read.csv("../data/DatosSemanalesVivaxClimaCompletissima.csv")
ncasesW$data <- as.Date(ncasesW$data)
ncasesWz <- zoo(ncasesW[,-1], ncasesW[,1])

## N de sites e ocasioes
totcasosW <- ncasesW$Vivax.cases
nIntervalsW <- length(totcasosW)

## Lista com dados
data.listW <- list(nIntervals=nIntervalsW, y=totcasosW)
## Valores iniciais baseados nos casos observados:
## Tive que usar valores fixos e baseados nos dados pq alternativas (comentadas)
## dao o famoso erro "Node inconsistent with parents"
initsW <- function() list(
                        N = ceiling(totcasosW*1/0.9+0.01),
                        r = log((totcasosW[-(length(totcasosW))]+0.01)/(totcasosW[-1]+0.01)),
                        lp = log(0.9/0.1)
                    )
## Parametros a acompanhar
pars <- c("N", "mu", "ypred", "p", "r")
## Parallel
fit2 <- jags.parallel(data = data.listW,
                      inits= initsW,
                      parameters.to.save = pars,
                      model.file = "poisson_model.jag",
                      n.iter = 3e6,
                      #n.burnin = 1.995e6,
                      n.chains=4,
                      export=c("totcasosW", "nIntervalsW"))
save.image()
save(fit2, ncasesW, ncasesWz, file="fit2.RData")
