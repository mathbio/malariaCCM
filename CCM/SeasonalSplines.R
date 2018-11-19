# This function obtains the yearly seasonal component of input time series using splines
# input
# DataFile: Name of the file to be analysed
# DateCol: Column of date variable 
# DateFormat: Date format 
# output
# Seasonal_[variable name].eps: plot for each variable with respective seasonality
# Seasonality_[file name].csv: spreadsheet with seasonality for all variables
SeasonalSplines<-function(DataFile='../data/DataMalariaTartagalCCM.csv',
                          DateCol=1,
                          DateFormat='%Y-%m-%d'){
  DataSeries<-read.csv(DataFile)
  OriginalDate<-as.Date(DataSeries[,DateCol], format=DateFormat)
  VariablesNames<-names(DataSeries)
  DataSeries[,DateCol]<-format(as.Date(DataSeries[,DateCol], DateFormat), format='%m/%d')
  AgDados<-aggregate(DataSeries[,-DateCol], by=list(DataSeries[,DateCol]), FUN=mean, na.rm=TRUE)
  AgDados[,DateCol]<-as.Date(AgDados[,DateCol],format='%m/%d')
  AuxDados<-format(AgDados[,DateCol], format='%m/%d')
  AuxAgDados<-format(DataSeries[,DateCol], format='%m/%d')
  AuxDados[which(is.na(AuxDados)==T)]<-'02/29'
  AuxAgDados[which(is.na(AuxAgDados)==T)]<-'02/29'
  test<-match(AuxAgDados,AuxDados)
  SeasonalData<-as.data.frame(matrix(NA,nrow(AgDados),(ncol(DataSeries))))
  SeasonalData[,1]<-seq(1,366)
  WDados<- table(DataSeries[,DateCol])
  Variables<-seq(1:ncol(DataSeries))[-DateCol]
  Seasonality<-as.data.frame(matrix(NA,NROW(DataSeries),NCOL(DataSeries)))
  Seasonality[,DateCol]<-OriginalDate
  count<-2
  for (i in Variables){
    AgDadosAux<-rep(AgDados[,i],3)
    SeasonalDataAux<-smooth.spline(AgDadosAux,w=rep(WDados,3))$y
    SeasonalData[,count]<-SeasonalDataAux[367:732]
    Seasonality[,count]<-SeasonalData[test,i]
    setEPS()
    postscript(paste('Seasonal_',VariablesNames[i],'.eps',sep=''),width=8.5,height=6)
    plot(OriginalDate,DataSeries[,i],ylab=VariablesNames[i],xlab='time')
    lines(OriginalDate,SeasonalData[test,i],col='blue',lwd=2)
    dev.off()
    count<-count+1
  }
  colnames(Seasonality)<-names(DataSeries)
  write.csv(Seasonality,paste('Seasonality_',basename(DataFile),sep=''),row.names = F)
}
