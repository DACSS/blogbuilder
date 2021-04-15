#' Builds a new DACSS blog
#'
#' Builds a new DACSS blog into a user-specified GitHub
#' repository. A generic DACSS blog will be
#' created with a Distill and Postcards setup. Assumes the user
#' has Git configured on their personal computer already.
#' The repo will be generated if it has not been setup already.
#' Simply follow the series of prompts when the function is called.
#'
#' @export
create_course_blog <- function() {
  selection <- utils::menu(c('No', 'Yes'),
                           title = 'Do you have a DACSS course repo setup already?')

  # Setup repo if user says 'No'
  if (selection == 1) {
    cat('Generating repo..\n')
    generate_repo()
  }

  # Repo link input
  repo_link <- readline('Please paste your DACSS repo link and hit enter: ')
  check_repo_syntax(repo_link)
  cat('GitHub repo: "', repo_link,'" retrieved successfully\n\n', sep = '')

  # User inputs directory path
  directory <- directory_input()

  # New project
  create_dacss_proj(repo_link, directory)
}


#' Builds student postcards
#'
#' Builds 'about me' pages for students in a Postcards setup. A spreadsheet
#' of student information is taken as input -- with names as a primary
#' requirement. Csv and xlsx formats are accepted.
#' It will also generate list of student names in the Student page.
#' Assumes the working directory is based on the GitHub blog repo prokect.
#'
#' @param spreadsheet A csv or xlsx file containing student names.
#' @param names_col The column containing student names. Can be the column
#' name or number.
#' @param theme The template theme to create postcard pages with. The default
#' value is "jolla".
#' @param ... Additional arguments can be taken based on arguments for
#' read_csv or read_xlsx.
#' @export
create_student_pages <- function(spreadsheet, names_col, theme = "jolla", ...) {
  names <- import_spreadsheet(spreadsheet, names_col, ...)

  for (name in names) {
    file_name <- paste(name, '.Rmd', sep = '')
    message(paste(name, 'created'))

    # Create postcard R Markdown files for each student
    postcards::create_postcard(file = name, template = theme,
                               edit = FALSE, create_image = FALSE)
    # Move file to users folder
    move_files(source_file = file_name, dest_path = './users')
  }

  message('Success. Student files created.')
}
