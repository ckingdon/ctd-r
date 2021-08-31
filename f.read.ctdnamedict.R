# read.ctdnamedict: read parameter names and units; used for header in output csv
# ARGS: seabird cnv file or OCE ctd object
# RETURNS: df linking GLERL data names (and units) to SBE AND OCE versons

read.ctdnamedict <- function(ctd){
  if (class(ctd)[1] == "ctd") {
    # assume it is an OCE ctd object
    ctdCast=ctd
    message(paste("read.ctdnamedict: ",
                  "ctd is an OCE ctd S4 object originally from file:\n",ctd@metadata$filename))
    #break
  } else if (file.exists(ctd) && !dir.exists(ctd)) {  # if it is a file, but not a directory
    # assume it's an SBE file
    #ctdCast=read.ctd.sbe(ctd,debug=0)
    ctdCast=suppressWarnings(read.ctd.sbe(ctd,debug=0))
    message(paste("read.ctdnamedict: ",
                  "ctd is from SBE cnv file:\n",ctd))
  }
  
  dataNamesCNV=unlist(ctdCast[['metadata']]['dataNamesOriginal'],use.names=FALSE)
  dataNamesOCE=names(unlist(ctdCast[['metadata']]['dataNamesOriginal']))
  dataNamesOCE=sub("dataNamesOriginal.","",dataNamesOCE)
  dataNamesProper=rep(NA,length(dataNamesCNV)) # placeholder for match loop below 
  dataUnitsProper=rep(NA,length(dataNamesCNV)) # placeholder for match loop below 
  # give "proper" names to parameters, make lookup "dict"
  dnuDict = make.namedict()
 
  # get index of names that match CNV from dict
  #match(dataNamesCNV,dnuDict$CNVName)
  m = 1
  for (i in match(dataNamesCNV,dnuDict$namesCNV)){
    #print(paste(i,m,dnuDict$ProperName[i]))
    dataNamesProper[m]=as.character(dnuDict$namesProper[i])
    dataUnitsProper[m]=as.character(dnuDict$unitsProper[i])
    #dataUnitsOCE[m]=ctdCast[['metadata']][['units']][[dataNamesOCE[i]]][1]
    m=m+1
  }
  
  # make dataframe
  df=cbind(dataNamesCNV,dataNamesOCE,dataNamesProper,dataUnitsProper)
  df=as.data.frame(df)
  
  return(df)
}

