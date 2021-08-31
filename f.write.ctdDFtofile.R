# write.ctdDFtofile
# ARGS: ctd dataframe, formatted text containing metadata
# RETURNS: df of station metadata with standardized column names

write.ctdDFtofile <- function(fName,metDF,ctdDF){
  if (!file.exists(fName)){
  
    fn = file(fName,open='a') # open file in append mode
  
    # reformat metDF as text
  
    writeLines(paste("#Lake,",metDF$mLake,"\n",
             "#Site name,",metDF$mSite_name,"\n",
             "#Program,",metDF$mProgram,"\n",
             "#Vessel,",metDF$mVessel,"\n",
             "#Latitude (degrees),",metDF$mLatitude,"\n",
             "#Longitude (degrees),",metDF$mLongitude,"\n",
             #"#Sample timestamp,",metDF$mSample_timestamp,"\n",
             "#Sample timestamp,",strftime(metDF$mSample_timestamp,"%m/%d/%Y %H:%M UTC"),"\n",
             "#Sensor device,",metDF$mSensor_device,"\n",
             "#Sensor serial number,",metDF$mSensor_serial_number,"\n",
             "#Note1,",metDF$mNote1,"\n",
             "#Note2,",metDF$mNote2,"\n",
             "#Note3,",metDF$mNote3,
             sep=""),fn)
  
    # write ctdDF names
    writeLines(paste(names(ctdDF),collapse=","),fn)
    # write ctdDF units
    nameDict = make.namedict()
    dataUnits = nameDict$unitsProper[match(names(ctdDF),nameDict$namesProper)]
    writeLines(paste(dataUnits,collapse=","),fn)
    # writd ctdDF data
    write.table(ctdDF,fn,sep=",",col.names=FALSE,row.names=FALSE,append=TRUE)
  
    # write ctdDF data
    close(fn)
    
  } else {
    message(paste("write.ctdDFtofile: FILE EXISTS!!!\n",fName))
  }
}
