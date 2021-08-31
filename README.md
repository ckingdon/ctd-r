# ctd-R

R functions and sample code to convert Seabird raw CTD (.cnv) files to GLERL-formatted .csv files.

```R
00-setup.R
f.clean.cnvdata.R
f.make.namedict.R
f.read.ctdancillary.R
f.read.ctdnamedict.R
f.read.stationsmd.R
f.write.ctdDFtofile.R
cleanupCTD_singlefile.R
```
#### `00-setup.R`

clears the environment and supresses warnings

#### `f.clean.cnvdata.R`

removes the in-water "soak" of the insturment at the beginning 
of the cast, as well as the upcast.

#### `cleanupCTD_singlefile.R`

This script demonstrates how to call functions. The output file contains a formatted 
header and ONLY the downcast data.
#


The OCE library for R  was used extensively.

[Dan Kelley's OCE pages](https://dankelley.github.io/oce/)

[OCE CRAN page](https://cran.r-project.org/web/packages/oce/index.html)

