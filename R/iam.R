#' Switch to Student Mode
#'
#' Exclude docs from the repo.
#'
#' @export
iamstudent <- function() {
  # correct_env() - DO NOT need to have correct env to exclude as students do not have .env.
  exclude_docs()
  message('Changed to student mode successfully!')
}

#' Switch to Instructor Mode
#'
#' Keep docs tracked.
#'
#' @export
iaminstructor <- function() {
  correct_env()
  lines <- readLines(".gitignore")[1:48]    #Removes docs/ from .gitignore.
  write(lines, '.gitignore')
  message('Changed to instructor mode successfully!')
}

