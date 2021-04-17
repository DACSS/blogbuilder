#' Exclude files in your repo
#'
#' Exclude files in your GitHub repo.
#' @param path The path to the file you want to exclude
#' @export
exclude_file <- function(path) {
  correct_env()
  exclude_template(path, file.exists)
}

#' Exclude directories in your repo
#'
#' Exclude directories in your GitHub repo
#' @param path The path to the directory you want to exclude
#' @export
exclude_dir <- function(path) {
  correct_env()
  exclude_template(path, dir.exists)
}

#' Exclude the docs folder
#'
#' Exclude the docs folder. Students will need to use
#' this function to ensure they do not commit
#' or push the docs folder to their forked repos.
#' @export
exclude_docs <- function() {
  correct_env()
  exclude_dir('docs/')
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
