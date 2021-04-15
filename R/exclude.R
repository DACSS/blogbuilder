#' Exclude files in your repo
#'
#' Exclude files in your GitHub repo.
#' @param path The path to the file you want to exclude
#' @export
exclude_file <- function(path) {
  exclude_template(path, file.exists)
}

#' Exclude directories in your repo
#'
#' Exclude directories in your GitHub repo
#' @param path The path to the directory you want to exclude
#' @export
exclude_dir <- function(path) {
  exclude_template(path, dir.exists)
}

# The template for excluding files or directories
exclude_template <- function(path, file_or_dir) {
  # Line in .gitignore does not exist
  if (!line_exists(path, file_or_dir)) {
    # Excludes file in .gitignore
    file_conn <- file('.gitignore', 'a')
    write(path, file_conn, append = TRUE)
    close(file_conn)

    message(paste(path, 'excluded successfully.'))
    # Line exists
  } else {
    stop(paste(path, 'is already excluded.'))
  }
}
