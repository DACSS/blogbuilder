instructor_form <- function() {
  message('Please fill out the following form: `https://forms.gle/CHPMt7zVWBrANTXdA`')
  utils::browseURL('https://forms.gle/CHPMt7zVWBrANTXdA')
  utils::menu(c('Proceed'), title = 'Press 1 once you are ready to proceed.')
  message('Please wait.. Generating student forms..'); Sys.sleep(8);
}

retrieve_student_form <- function(repo) {
  row <- retrieve_row(repo)
  student_forms <- retrieve_form_values(row, 'Student Forms')

  if (is.na(student_forms)) {
    warning('Please try again with `get_student_form()` later.')
  } else {
    return(student_forms)
  }
}

retrieve_row <- function(repo, initialize = FALSE) {
  data <- googlesheets4::read_sheet('1Sh0iHzIehQJkrCtXOiB9xx5cH9cVPgTn8J8-L_IZgSU')
  row <- data[which(data$`Course Repo` == repo), ]

  if (initialize == TRUE) {
    initialize_env(row)
  }

  return(row)
}

retrieve_form_values <- function(row, column) {
  values <- tryCatch(
      row[[column]],
      error = function(e) {
        message(paste('Column:', column, 'does not exist.'))
        return(NULL)
      },
      finally = {
        return(row[[column]])
      }
  )
  return(values)
}


