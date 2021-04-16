# Creates a new R project from a GitHub repo
create_dacss_proj <- function(repo_link, directory) {
  if (length(directory) == 0L) {
    stop('Directory choosen is invalid.')
  # Creates new R project based on user repo
  } else {
    out <- tryCatch(
      usethis::create_from_github(
        repo_link,
        destdir = directory,
        fork = FALSE,
        rstudio = TRUE,
        open = TRUE
      ),
      error = function(e) {
        cat('There is an error with your GitHub configuration.\n',
            'Use the command usethis::git_sitrep() to diagnose your issue.\n',
            'If it is a email issue use usethis::use_git_config(user.name = "YOUR_ACCOUNT", user.email = "GITHUB_EMAIL")\n',
            'If it is a token issue use usethis::gh_token_help()\n\n',
            'After you have configured your account, please run this function again: create_course_blog().\n',
            'You do not need to create a new repo or fill out the form again.\n\n', sep = '')
        return(FALSE)
      }
    )

    if (length(out)) message('New R project created. Please wait before proceeding.')
    return(out)
  }
}

# Update project based on environment variables
initialize_project <- function(data) {
  message('\nInitializing project with your configurations...')

  # For now, updates instructor name
  update_instructor_name(data$`Instructor Name`)

  message(paste('\n\nHere is your Student Forms:', data$`Student Forms`))
  message('Head over to the link and restore the folder needed to store your responses.')
  message('Project successfully configured. You may close this RStudio session now if you want.')
}

# Checks status with google
google_status <- function() {
  message('Checking if user is authenticated with Google...')

  # User is not authenticated
  if (!googlesheets4::gs4_has_token()) {
    message('Your account needs to be configured.')
    message('Please use your UMass email if possible.')
    message('Redirecting to Google Authentication menu...\n')
    Sys.sleep(2)

    googlesheets4::gs4_auth()
    google_status()
  } else {
    message('Your account is configured properly.\n')
  }
}

# Allows user input in selecting a directory
directory_input <- function() {
  message('Attempting to create a new R Project with course repo...')
  cat('Please choose a directory you would like to store the new R project.\n\n')
  Sys.sleep(1)
  directory <- easycsv::choose_dir()
  return(directory)
}

# Updates YAML headers programmatically
# Original code by @r2evans: https://stackoverflow.com/users/3358272/r2evans
change_yaml_matter <- function(input_file, ..., output_file) {
  input_lines <- readLines(input_file)
  delimiters <- grep("^---\\s*$", input_lines)
  if (!length(delimiters)) {
    stop("unable to find yaml delimiters")
  } else if (length(delimiters) == 1L) {
    if (delimiters[1] == 1L) {
      stop("cannot find second delimiter, first is on line 1")
    } else {
      # found just one set, assume it is *closing* the yaml matter;
      # fake a preceding line of delimiter
      delimiters <- c(0L, delimiters[1])
    }
  }
  delimiters <- delimiters[1:2]
  yaml_list <- yaml::yaml.load(input_lines[(delimiters[1]+1):(delimiters[2]-1)])

  dots <- list(...)
  yaml_list <- c(yaml_list[setdiff(names(yaml_list), names(dots))], dots)

  output_lines <- c(
    if (delimiters[1] > 0) input_lines[1:(delimiters[1])],
    strsplit(yaml::as.yaml(yaml_list), "\n")[[1]],
    input_lines[-(1:(delimiters[2]-1))]
  )

  if (missing(output_file)) {
    return(output_lines)
  } else {
    writeLines(output_lines, con = output_file)
    return(invisible(output_lines))
  }
}

# Import spreadsheet of student names
import_spreadsheet <- function(spreadsheet, names_col, ...) {
  type <- determine_spreadsheet(spreadsheet)
  names <- NULL

  message(paste(type, 'format detected.'))

  # Reads in data based on file types
  if (type == 'csv') {
    df <- readr::read_csv(spreadsheet, ...)
  } else if (type ==  'xlsx') {
    df <- readxl::read_xlsx(spreadsheet, ...)
  }
  else stop(paste(type, 'is not a supported file type.'))

  if (is.null(df)) stop('An error has occured with the spreadsheet.')
  if (!(names_col %in% colnames(df)) & typeof(names_col) == 'character') {
    stop(paste(names_col, 'does not exist in the DataFrame.'))
  }

  # Vector of student names
  names <- df[[names_col]]

  return(names)
}


# Determines if spread is an Excel file or CSV
determine_spreadsheet <- function(spreadsheet) {
  if (endsWith(spreadsheet, ".csv")) return("csv")
  else if (endsWith(spreadsheet, ".xlsx")) return("xlsx")
  else return(NULL)
}

# Move files to different directories
move_files <- function(source_path = '.', dest_path = '.',
                       source_file, dest_file = source_file) {

  file.rename(from = file.path(source_path, source_file),
              to = file.path(dest_path, dest_file))
}

# Previews site after a build
preview_site <- function(success_message) {
  message(success_message)
  Sys.sleep(1)
  # Opens up index html (homepage) in browser
  utils::browseURL(paste('file://', file.path(getwd(), '/docs/index.html'), sep = ''))
}
