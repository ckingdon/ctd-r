# make.namedict: read parameter names and units; used for header in output csv
# ARGS: none
# RETURNS: df linking SBE data names to GLERL data names (and units)

make.namedict <- function(){
  
  dnuDict=data.frame(rbind(c("depFM","depth","meter"),
                           c("tv290C","water temperature","degrees Celsius"),
                           c("c0uS/cm","conductivity", "uS/cm"),
                           c("specc","specific conductance", "uS/cm"),
                           c("sbeox0Mg/L","dissolved oxygen", "mg/L"),
                           c("sbeox0PS","dissolved oxygen saturation", "%"),
                           c("par","photosynthetically active radiation (PAR)", "uE/m2/s"),
                           c("CStarAt0","beam attenuation", "1/m"),
                           c("CStarTr0","beam transmission", "%"),
                           c("flECO-AFL","flourescence chlorophyll", "ug/L"),
                           c("chloroflTC0","fluorescence chlorophyll", "ug/L"),
                           c("phycyflTC0","fluorescence phycocyanin", "ug/L"),
                           c("flag","flag", "na"))
  )
 
  #colnames(dnuDict)=c("CNVName","ProperName","Units")
  colnames(dnuDict)=c("namesCNV","namesProper","unitsProper")
  
  return(dnuDict)
  
}