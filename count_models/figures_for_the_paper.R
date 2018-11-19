      library(grid)
      library(ggthemes)


## Theme for publication-quality plots (https://rpubs.com/Koundy/71792)
theme_Publication <- function(base_size=14, base_family="helvetica") {
      (theme_foundation(base_size=base_size, base_family=base_family)
       + theme(plot.title = element_text(face = "bold",
                                         size = rel(1.2), hjust = 0.5),
               text = element_text(),
               panel.background = element_rect(colour = NA),
               plot.background = element_rect(colour = NA),
               panel.border = element_rect(colour = NA),
               axis.title = element_text(face = "bold",size = rel(1)),
               axis.title.y = element_text(angle=90,vjust =2),
               axis.title.x = element_text(vjust = -0.2),
               axis.text = element_text(size=rel(2)), 
               axis.line = element_line(colour="black", size=1.1),
               axis.ticks = element_line(size=1.1),
               panel.grid.major = element_line(colour="#f0f0f0"),
               panel.grid.minor = element_blank(),
               legend.key = element_rect(colour = NA),
               legend.position = "bottom",
               legend.direction = "horizontal",
               legend.key.size= unit(0.2, "cm"),
               legend.margin = margin(0, "cm"),
               legend.title = element_text(face="italic"),
               plot.margin=unit(c(10,5,5,5),"mm"),
               strip.background=element_rect(colour="#f0f0f0",fill="#f0f0f0"),
               strip.text = element_text(face="bold")
          ))
      
}

scale_fill_Publication <- function(...){
      library(scales)
      discrete_scale("fill","Publication",manual_pal(values = c("#386cb0","#fdb462","#7fc97f","#ef3b2c","#662506","#a6cee3","#fb9a99","#984ea3","#ffff33")), ...)

}

scale_colour_Publication <- function(...){
      library(scales)
      discrete_scale("colour","Publication",manual_pal(values = c("#386cb0","#fdb462","#7fc97f","#ef3b2c","#662506","#a6cee3","#fb9a99","#984ea3","#ffff33")), ...)

}

################################################################################

## Credibility intervals for the number of cases, takeing all sources of uncertainty
## Done by simulation
## A sample of size = 500 from posterior
r.ind <- sample(nrow(fit2$BUGSoutput$sims.list$mu), size = 500)
t.int <- ncol(fit2$BUGSoutput$sims.list$mu) ## number of time steps
results <- matrix( nrow = length(r.ind), ncol=)
for(i in 1:length(r.ind)){
    results[i,]  <- 
        rpois(t.int, fit2$BUGSoutput$sims.list$mu[r.ind[i]]) %>%
        rbinom(t.int, size=., prob = fit2$BUGSoutput$sims.list$p[r.ind[i]]
        
    }

totaisW.df %>%
    ggplot(aes(data, obs)) +
    geom_line(colour="red") +
    geom_line(aes(data, Ncasos), colour="darkblue", size=1.25)+
    geom_ribbon(aes(ymin=Ncasos.low, ymax=Ncasos.up), fill="blue", alpha=0.5) +
    ylab("Number of weekly cases") +
    xlab("Date") +
    theme_Publication()

ggsave("Ncases_and_expected.pdf", width=12, height=7.5, device=cairo_pdf)
