#' @importFrom dplyr filter mutate
seaice_sync_nsidc_south <- function(pattern = NULL, local_file_root = "") {
  aconfig <- config_filter_names(seaice_config, c("NSIDC SMMR-SSM/I Nasateam sea ice concentration",
               "NSIDC SMMR-SSM/I Nasateam near-real-time sea ice concentration")
  )
  aconfig <- config_sync_all(aconfig)
  if (!is.null(pattern)) {
    for (i in seq_along(pattern)) {
      newtok <- "--accept=\"*%s*\""
      aconfig[["method_flags"]] <- paste(aconfig[["method_flags"]], sprintf(newtok, pattern[i]))
    }

  }
  if (nchar(local_file_root) > 0) aconfig$local_file_root <- local_file_root
  stopifnot(all(file.exists(aconfig$local_file_root)))
  raadsync::sync_repo(aconfig)
}
raw_file_list <- function(datadir = "") {
  if (nchar(datadir) == 0L) stop()
  tbl(src_sqlite(file.path(datadir, "raw_file_list.sqlite3"), "files"))
}
update_raw_file_list <- function(datadir = "") {
  if (nchar(datadir) == 0L) stop()
  db <- src_sqlite(file.path(datadir, "raw_file_list.sqlite3"), create = TRUE)
  files <- tibble(fullname = list.files(datadir, recursive = TRUE, full.names = TRUE))
  dplyr::copy_to(db, files, temporary = FALSE)
}
#' @importFrom dplyr filter
config_filter_names <- function(x, ds_names) {
    filter(x, name %in% ds_names)
}
#' @importFrom dplyr mutate
config_sync_all <- function(x) {
  mutate(x, do_sync = TRUE)
}
#' @importFrom dplyr mutate
config_sync_none <- function(x) {
  mutate(x, do_sync = TRUE)
}
