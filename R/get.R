#' Get Blog Student Form
#'
#' Retrieve a course blog's student form link.
#'
#' @export
get_student_form <- function() {
  correct_env()

  link <- Sys.getenv('STUDENT_FORMS')

  # Print out link value
  if (nchar(link) > 0) {
    message(paste('Student form link:', link))
  # Invalid env value / link
  } else {
    stop('Student form not found. Perhaps try resetting the project environment with `reset_project_env()`')
  }
}
