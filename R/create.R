#' Builds a new DACSS blog
#'
#' Builds a new DACSS blog into a user-specified GitHub
#' repository. A generic DACSS blog will be
#' created with a Distill and Postcards setup. Checks if the user
#' has Git configured on their personal computer. The repo will be generated
#' if it has not been setup already. Also asks the user to authenticate their
#' Google account. Simply follow the series of prompts when the function is called.
#'
#' @export
create_course_blog <- function() {
  # Check if Git is configured properly
  gh_status()

  # Menu for repo template
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

  # Checks Google authentication
  google_status()
  # Instructor form
  instructor_form()

  # User inputs directory path
  directory <- directory_input()
  repo_name <- strsplit(repo_link, "/+")[[1]][4] # [[1]][4] represents GitHub repo name
  new_proj_path <- paste(directory, '/', repo_name, sep = '')

  # Choosen directory has folder that exists
  if (dir.exists(new_proj_path)) stop(paste(new_proj_path, 'already exists.'))

  # New project
  if (length(create_dacss_proj(repo_link, directory))) {
    setwd(new_proj_path)

    # Update course
    row <- retrieve_row(repo_link, initialize = TRUE)
    initialize_project(row)
  }
}


#' Builds student postcards
#'
#' Builds 'about me' pages for students in a Postcards setup. A spreadsheet
#' of student information is taken as input -- with names as a primary
#' requirement. Csv, xlsx, and Google Spreadsheet formats are accepted.
#' It will also generate list of student names in the Student page.
#' Assumes the working directory is based on the GitHub blog repo prokect.
#'
#' @param spreadsheet A csv, xlsx, or Google Spreadsheet file containing student names.
#' @param names_col The column containing student names. Can be the column
#' name or number.
#' @param theme The template theme to create postcard pages with. The default
#' value is "jolla".
#' @param ... Additional arguments can be taken based on arguments for
#' read_csv or read_xlsx.
#' @export
create_student_pages <- function(spreadsheet, names_col, theme = "jolla", ...) {
  correct_env()

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
