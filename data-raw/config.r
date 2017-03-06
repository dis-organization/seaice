# library(raadtools)
# scf <- icefiles()
# ncf <- icefiles(hemisphere = "north")
# file.copy(tail())


#devtools::install_github("AustralianAntarcticDataCentre/raadsync")
ucfg <- "https://raw.githubusercontent.com/AustralianAntarcticDataCentre/raadsync/master/inst/extdata/raad_repo_config.json"
tdir <- tempdir()
library(curl)
cfile <- file.path(tdir, basename(ucfg))
curl_download(ucfg, cfile)
library(raadsync)
config <- raadsync::read_repo_config(cfile)
library(dplyr)
seaice_config <- filter(config, grepl("nsidc", name, ignore.case = TRUE)) %>%
  tibble::as_tibble()

devtools::use_data(seaice_config)
