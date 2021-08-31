# read.stationsmd
# ARGS: formated csv file with details about stations, column names
# RETURNS: df of station metadata with standardized column names
read.stationsmd <- function(csv,sidcol,yrcol,latcol,loncol){
  # get station locations from specified CSV file
  # CSV's first row should be column names
  df=read.csv(csv)
  df=df[ , c(sidcol,yrcol,latcol,loncol)]
  colnames(df)=c("SID","YR","LAT","LON")
  return(df)
}
