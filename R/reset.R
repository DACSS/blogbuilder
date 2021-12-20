#' Reset project env
#'
#' Reset the project environment.
#' @export
reset_project_env <- function() {
  correct_env()

  # Confirmation prompt
  selection <- utils::menu(c('No', 'Yes'),
                          title = paste('Are you sure you want to reset your project environment',
                                        'to its default settings?\nNote: this cannot be undone.'))

  if (selection == 1) { # No
    message('Cancelling reset...')
  } else { # Yes
    repo <- Sys.getenv('COURSE_REPO')

    if (repo == 'NA') {
      repo <- readline(prompt = "Please paste in your course blog repo link: ")
    } else {
      googlesheets4::gs4_deauth()
      row <- retrieve_row(repo)

      # Valid row
      if (length(row)) {
        file.remove('.env')
        initialize_env(row)

        #The env has been changed, reflect those changes in the site.
        #----------------
        update_course_title(Sys.getenv('COURSE_TITLE'))
        update_course_semester(Sys.getenv('SEMESTER'))
        update_course_instructor(Sys.getenv('INSTRUCTOR_NAME'), Sys.getenv('INSTRUCTOR_PROF_PIC'))
        #----------------

        message('Success. Environment reset.')
      # Invalid row
      } else {
        warning('Repo not found. Please try again.')
      }
    }
  }
}
