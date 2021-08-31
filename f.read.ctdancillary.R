# read.ctdancillary
# ARGS: seabird cnv file, station ID, station metatdata
# RETURNS: df w/ details about (one) station, specfically: 
# StationID|InstrumentModel|SerialNumber|CastDateTime|Year|Latitude|Longitude

read.ctdancillary <- function(ctdCNV,stationID,stationsMD){
  # if stationID has been provided then update ctd metadata ----
  if(!missing(stationID)){ # if *not* missing stationID
    #ctdCast=read.ctd.sbe(ctdCNV,station=stationID,debug=0) # OCE library
    ctdCast=suppressWarnings(read.ctd.sbe(ctdCNV,station=stationID,debug=0)) # OCE library
  } else {
    #ctd=read.ctd.sbe(ctdCNV,debug=0) # OCE library
    ctdCast=suppressWarnings(read.ctd.sbe(ctdCNV,debug=0)) # OCE library
  }
  
  # get Station ID ----
  sid=ctdCast[['metadata']]['station']
  sid=trimws(sid,which=c("both"))
  #sid=ctdCast@metadata$station
  
  # instrument serial number i.e. (main) temperature sensor ----
  sno=ctdCast[['metadata']]['serialNumberTemperature']
  sno=trimws(sno,which=c("both"))
  
  # instrument model ----
  hdr=ctdCast[['metadata']]['header']
  hdrlst=strsplit(hdr[[1]],'\r')
  ins=hdrlst[1]
  ins=gsub("\\*\\s","",ins)
  ins=gsub("\\sData File:","",ins)
  ins=trimws(ins,which=c("both"))
  
  # cast time ----
  cst=ctdCast[['metadata']]['startTime']
  cst=as.POSIXlt(strptime(cst[[1]],format='%Y-%m-%d %H:%M:%S',tz="PDT"))
  #cst=as.POSIXct(cst,tz="PDT")
  cst=as.POSIXct(cst)
  cst = cst + 8*3600
  attributes(cst)$tzone = "UTC"
  cst=strftime(cst,format='%Y-%m-%d %H:%M:%S',tz="UTC") # convert back to str?
  
  # if stationYR has not been provided then get it from cast time ----
  stationYR=strftime(cst,format='%Y')
  # if(!missing(stationYR)){
  #   stationYR=strftime(cst,format='%Y')
  # } else {
  #   stationYR=9999
  # }
  
  # get lat/lon ----
  # if no lat/lon in header, look for stationsMD file
  lat=ctdCast[['metadata']]['latitude']; lon=ctdCast[['metadata']]['longitude']
  #if (is.na(lat) | is.na(lon)){
  if ((is.na(lat) | is.na(lon)) & stationID %in% stationsMD$SID){
    lxy=stationsMD[which(stationsMD$SID==stationID & stationsMD$YR==stationYR),c("LAT","LON")]
    #lat=lxy[1]; lon=lxy[2]
    lat=lxy[[1]]; lon=lxy[[2]]
  } else {
    lat=9999; lon=9999
  }
  
  # make dataframe w/ details about station ---- 
  df=data.frame(sid,ins,sno,cst,stationYR,lat,lon)
  names(df) = c("StationID","InstrumentModel","SerialNumber","CastDateTime",
                "Year","Latitude","Longitude")
  return(df)
}

