#rm(list=ls())
#options(warn=-1)
options(warn=0)

# source functions ----
setwd("/home/kingdon/Documents/UM_CIGLR/c/CTD-code-R/working/")
source("../00-setup.R")
source("../f.read.stationsmd.R")
source("../f.read.ctdancillary.R")
source("../f.read.ctdnamedict.R")
source("../f.clean.cnvdata.R")
source("../f.make.namedict.R")
source("../f.write.ctdDFtofile.R")
# ----

# specify file to process
cnv="../sample_data/CHRP9.cnv"
cnv="../sample_data/CHRP3.cnv"
cnv="../sample_data/CHRP5.cnv"
cnv="../sample_data/CHRP7.cnv"
cnv="../sample_data/SBE19plus_01906619_2020_07_13_0001.cnv"

# get station ID from ctdfn
stationid=basename(cnv)
stationid=unlist(strsplit(stationid,"[.]"))[1]

# read csv file that has station/year/lat/lon
# format the csv file like this ...
stationsMetadataDF = read.stationsmd("../sample_data/chrp_mooring_lat_lon.csv",
                "station", 'year', "lat_spar", "lon_spar")

# get data name dictionary
namDF=read.ctdnamedict(cnv)

# read ancillary data about station/mooring
ancDF=read.ctdancillary(cnv,stationid,stationsMetadataDF)

# specify data columns to process
d2proc=c("all")
d2proc=c("conductivity","water temperature") # in addition to depth
d2proc=c("conductivity","water temperature","specific conductance",
         "beam attenuation") # in addition to depth

# remove soak upto specified depth
ctdDF=clean.cnvdata(cnv,d2proc,3)
ctdDF=clean.cnvdata(cnv,d2proc)

# write data to file ----
# user-specified metadata
mLake ="Erie"
mSite_name = ancDF$StationID
mProgram = "NOAA/GLERL CHRP Monitoring"
mVessel = "R/V 5501"
mLatitude = ancDF$Latitude
mLongitude = ancDF$Longitude
mSample_timestamp = ancDF$CastDateTime
mSensor_device = ancDF$InstrumentModel
mSensor_serial_number = ancDF$SerialNumber
mNote1 = strwrap("PAR sensor was a Biospherical Instrument QSP-2300. Beam 
                attenuation sensor was a WET Labs C-Star. Chlorophyll and 
                phycocyanin sensor was a Turner Cyclops.",width=1000)
mNote2 = strwrap("Raw data available in .cnv file, which can be opened with 
                 a text editor. The start time listed in the .cnv file is PDT 
                 time zone.",width=1000)
mNote3 = "These data were collected for research purposes."

metadataDF = data.frame(mLake,mSite_name,mProgram,mVessel,mLatitude,mLongitude,
                   mSample_timestamp,mSensor_device,mSensor_serial_number,
                   mNote1,mNote2,mNote3)

outDir = "/home/kingdon/Documents/UM_CIGLR/c/CTD-code-R/sample_output/"
outFile = paste("glerl_",mLake,"_ctd_",ancDF$StationID,"_d",
              strftime(ancDF$CastDateTime,"%Y%m%d%H%M"),"z",".csv",sep="")
outFile = paste(outDir,outFile,sep="") # canonical file name

write.ctdDFtofile(outFile,metadataDF,ctdDF)




# getting to know OCE
#rm(list=ls())
#dev.off()
ctdProfile = read.ctd.sbe(cnv,station=stationid) # OCE library

ctdProfile@metadata$latitude
ctdProfile@metadata$longitude
ctdProfile@metadata$latitude = ancdf$Latitude
ctdProfile@metadata$longitude = ancdf$Longitude

data(ctdProfile)
plot(ctdProfile,span=500)
plot(ctdProfile,which=1,span=500)
plot(ctdProfile,which=2,span=500)
plot(ctdProfile,which=3,span=500)
plot(ctdProfile,which=c(1,3,4,5),span=1500,coastline="best")




