#' @importFrom usethis create_from_github
create_dacss_proj <- function(repo_link, directory) {
  if (length(directory) == 0L) {
    stop('Directory is invalid.')
  # Creates new R project based on user repo
  } else {
    create_from_github(
      repo_link,
      destdir = directory,
      fork = FALSE,
      rstudio = FALSE,
      open = TRUE
    )
  }
}

#' @importFrom usethis create_from_github
directory_input <- function() {
  cat('Please choose a directory you would like to store the new R project.\n\n')
  Sys.sleep(1)
  directory <- choose_dir()
  return(directory)
}
