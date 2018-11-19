## ----setup, echo=FALSE, warning=FALSE, message=F-------------------------
library(knitr); library(zoo); library(xts)
library(ggplot2)#; library(cowplot)
library(dplyr); library(tidyr); library(ggmap);
library(rjags); library(R2jags)

opts_chunk$set(fig.align = 'center', fig.show = 'hold', fig.height = 4,
               warning = FALSE, message = FALSE, error = FALSE, echo=FALSE)
options(formatR.arrow = TRUE,width = 90, cache=TRUE)

## ----data reading--------------------------------------------------------
ncases <- read.csv("../data/DataMalariaTartagalCCM.csv")
ncases$date <- as.Date(ncases$date, "%d/%m/%Y")
summary(ncases)
ncasesz <- zoo(ncases[,-1], ncases[,1])
plot(ncasesz$cases, ylab="Number of cases")

## ----Poisson model, eval=FALSE-------------------------------------------
## 
## ## N de sites e ocasioes
## totcasos <- ncases$cases
## nIntervals <- length(totcasos)
## 
## ## Lista com dados
## data.list <- list(nIntervals=nIntervals, y=totcasos)
## ## Valores iniciais baseados nos casos observados:
## ## Tive que usar valores fixos e baseados nos dados pq alternativas (comentadas)
## ## dao o famoso erro "Node inconsistent with parents"
## inits <- function() list(
##                         N = rpois(length(totcasos), totcasos*1/0.8+0.01),
##                         r = rnorm((nIntervals-1), log((totcasos[-(length(totcasos))]+0.01)/(totcasos[-1]+0.01)),0.1),
##                         lp = rnorm(2,0.1)
##                     )
## 
## ## inits <- function() list(
## ##                         N = ceiling(totcasos*1/0.5+0.01),
## ##                         r = log((totcasos[-(length(totcasos))]+0.01)/(totcasos[-1]+0.01)),
## ##                         lp = log(0.1/0.9)
## ##                     )
## ## Parametros a acompanhar
## pars <- c("N", "mu", "ypred", "p", "r")
## ## Parallel
## fit1 <- jags.parallel(data = data.list,
##                       inits= inits,
##                       parameters.to.save = pars,
##                       model.file = "poisson_model.jag",
##                       n.iter = 1.5e5,
##                       n.burnin = 1.45e5,
##                       n.chains=4,
##                       export=c("totcasos", "nIntervals"))
## save.image()

## ----plots---------------------------------------------------------------
## Predicted x observed number of cases
tmp <- fit1$BUGSoutput$summary
totais <- zoo(
    data.frame(obs=ncases$cases, 
               Ncasos=tmp[grep("ypred",rownames(tmp)),"mean"],
               Ncasos.low=tmp[grep("ypred",rownames(tmp)),"2.5%"],
               Ncasos.up=tmp[grep("ypred",rownames(tmp)),"97.5%"]),
    order.by=as.Date(ncases$date))
## N de casos obs e previsto
totais.df <- totais %>%
    fortify() %>%
    mutate(data=as.Date(Index))
totais.df %>%
    ggplot(aes(data, obs)) +
    geom_line(colour="red", lwd=0.8) +
    geom_line(aes(data, Ncasos), colour="blue")+
    geom_ribbon(aes(ymin=Ncasos.low, ymax=Ncasos.up), fill="blue", alpha=0.25) +
    scale_y_continuous(name="N cases") +
    theme_bw()

## Save the predicted data
write.csv(totais.df, file="predicted_cases_poisson_model.csv", row.names=FALSE)

## ----posterior p detection-----------------------------------------------
plot(as.mcmc(fit1)[,"p"])

## ----Weekly data reading-------------------------------------------------
ncasesW <- read.csv("../data/DatosSemanalesVivaxClimaCompletissima.csv", as.is=TRUE)
ncasesW$data <- as.Date(ncasesW$data)
ncasesWz <- zoo(ncasesW[,-1], ncasesW[,1])
plot(ncasesWz$Vivax.cases, ylab="Number of cases")

## ----Weekly plots--------------------------------------------------------
## Load the results of the Bayseian fit, that I ran in a cluster
load("fit2.RData")
## Predicted x observed number of cases
tmp2 <- fit2$BUGSoutput$summary
totaisW <- zoo(
    data.frame(obs=ncasesW$Vivax.cases, 
               Ncasos=tmp2[grep("ypred",rownames(tmp2)),"mean"],
               Ncasos.low=tmp2[grep("ypred",rownames(tmp2)),"2.5%"],
               Ncasos.up=tmp2[grep("ypred",rownames(tmp2)),"97.5%"],
               NI=tmp2[grep("N",rownames(tmp2)),"mean"],
               NI.low=tmp2[grep("N",rownames(tmp2)),"2.5%"],
               NI.up=tmp2[grep("N",rownames(tmp2)),"97.5%"]),
    order.by=as.Date(ncasesW$data))
## N de casos obs e previsto
totaisW.df <- totaisW %>%
    fortify() %>%
    mutate(data=as.Date(Index))
totaisW.df %>%
    ggplot(aes(data, obs)) +
    geom_line(colour="red") +
    geom_line(aes(data, Ncasos), colour="blue")+
    geom_ribbon(aes(ymin=Ncasos.low, ymax=Ncasos.up), fill="blue", alpha=0.5) +
    scale_y_continuous(name="N cases") +
    theme_bw()

## Total de doentes
## totaisW.df %>%
##     ggplot(aes(data, NI)) +
##     geom_line() +
##     geom_ribbon(aes(ymin=NI.low, ymax=NI.up),alpha=0.25) +
##     scale_y_continuous(name="N Infected") +
##     theme_bw()

## Save the predicted data
write.csv(totaisW.df, file="predicted_cases_poisson_model_weekly.csv", row.names=FALSE)

## ----Weekly posterior p detection----------------------------------------
plot(as.mcmc(fit2)[,"p"])

