# clean.cnvdata
# ARGS: seabird cnv file, list (vector) of parameters to process
# RETURNS: downcast data as a dataframe

clean.cnvdata <- function(ctdCNV,procColumns,soakDepth){
  if(missing(procColumns)) {
    procColumns=c("all")
  }
  if(missing(soakDepth)) {
    soakDepth = 0.8
  }
  message(paste("procColumns is: ",procColumns))
  message(paste("soak depth is: ",soakDepth))
  #ctdCast=read.ctd.sbe(ctdCNV) # OCE library
  ctdCast=suppressWarnings(read.ctd.sbe(ctdCNV)) # OCE library
 
  depSoak = soakDepth
  depth=ctdCast@data$depth         # depth profile
  depMax=max(depth)                # maximum depth
  depMaxPos=(which(depth==depMax)) # index of maximum depth
  depMaxPos=depMaxPos[1]           # get first one .. jic more than one max value
  
  # GET GOOD MEASUREMENTS: see notes below function ----
  # get longest continuous increasing subsequence, starting at depth that is 
  # shallower than soakDepth, if necessary
  i = 1
  n = NULL # jic
  n1 = NULL
  depMinPos = NULL
  
  for (n in rev(depth[1:depMaxPos])){
    # check if n1 is null on first iteration ...
    i = i + 1
    if (is.null(n1)){
      #print("n1 is null")
      n1 = n
    } 
    # ... if n1 is not null then continue ...
    else {    # all other iterations
      # if current depth is shallower than previous, continue upward
      if (n < n1){
        #print(paste(i,n,n1,"n LT n1",sep=" | "))
        n1 = n
        next
      }
      # if current depth is deeper than previous depth then ...
      if (n > n1){
        #print(paste(i,n,n1,"n GT n1",sep=" | "))
        n1 = n
      }
        # check if depth is < soakDepth (m) ...
        if (n < depSoak){
          depMinPos = depMaxPos - i + 1 + 2 # ... and get index of minimum depth of good data
          print(paste("depMinPos: ",depMinPos,"|","minimum depth: ",depth[depMinPos],"<-- LCIS start"))
          break
        }
    }
  }
  print(paste("depMaxPos: ",depMaxPos,"|","maximum depth: ",depth[depMaxPos]))
  # ----
 
  # subset good data
  gDataRange = c(depMinPos,depMaxPos)
  ctdDowncast = subset(ctdCast,indices=gDataRange[1]:gDataRange[2]) # OCE subset function
  
  # get all or selected columns ----
  # rename columns to "proper" GLERL names: see read.ctdnamedict()
  nameDict = read.ctdnamedict(ctdDowncast)
  if (procColumns=="all"){
    # include all data columns
    cnvNames = names(ctdDowncast@metadata$dataNamesOriginal)
    dfDowncast = as.data.frame(ctdDowncast@data)
    names(dfDowncast)
    #dfDowncast = dfDowncast[c(1,2,7,6,5,3,4,8:length(names(dfDowncast)))]  # test mixed order
    reorderIdx = match(names(dfDowncast),cnvNames)  # back to original order
    reorderIdx = reorderIdx[!is.na(reorderIdx)] # remove OCE's salinity & pressure columns indices
    dfDowncast = dfDowncast[reorderIdx]
    oceNamesIdx = match(names(dfDowncast),nameDict$dataNamesOCE) # get index of repsective "proper" name
    oceNamesIdx = oceNamesIdx[!is.na(oceNamesIdx)] # remove OCE's salinity & pressure columns indices
    dfDowncast = dfDowncast[oceNamesIdx] # keep only columns from cnv/sbe file (ie drop OCE additions) 
    oceNamesIdx = match(names(dfDowncast),nameDict$dataNamesOCE) # get index of repsective "proper" name
    oceNamesIdx = oceNamesIdx[!is.na(oceNamesIdx)] # remove OCE's salinity & pressure columns indices
    names(dfDowncast) = nameDict$dataNamesProper[oceNamesIdx]  # add "proper" names
    names(dfDowncast)
  } else {
    # include only specified columns, but always include depth
    dfDowncast = as.data.frame(ctdDowncast@data)
    oceNamesIdx = match(procColumns,nameDict$dataNamesProper)
    dfDowncast = dfDowncast[oceNamesIdx]
    dfDowncast = cbind(ctdDowncast@data$depth,dfDowncast)
    names(dfDowncast) = c("depth",procColumns)
  }
  # ----
  
  # whatever you do, don't run ctdDecimate
  #plotProfile(ctdDecimate(ctdDowncast))
  
  #dfDowncast = as.data.frame(ctdDowncast@data)
  df=dfDowncast
  return(df)
}

# GET GOOD MEASUREMENTS by removing soak-period data upto specified depth ----
# Find the position of the first good measurement. This requires working 
# backward from the maximum depth to <0.8m of [soakDepth] depth, then finding 
# the last position that is descending order.
# Good data is from the minimum list position [depMinPos] to the maximum list 
# position [depMaxPos]
# Data at beginning is clipped off due to sensor bobbing in the water at the 
# beginning of the cast while adjusting to water temperature.
# ----

# ctdTrim methods ----
# need to learn more about how these work
# https://dankelley.github.io/oce/articles/ctd.html#example-with-raw-data-1
#ctdDowncast=ctdTrim(ctdCast,method='index',parameters=gDataRange)  # OCE function
#ctdDowncast=ctdTrim(ctdCast,method='range',
#            parameters=list(item="scan",from=gDataRange[1],to=gDataRange[2]))
#ctdCastDownMethod=ctdTrim(ctdCast,method='downcast')  # OCE function
#ctdCastSoakMethod=ctdTrim(ctdCast,method='sbe')  # OCE function
# ----
  