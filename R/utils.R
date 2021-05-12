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

    # Output is not empty, so project creation is a success
    if (length(out)) message('New R project created. Please wait before proceeding.')
    return(out)
  }
}

# Update project based on environment variables
initialize_project <- function(data) {
  message('\nInitializing project with your configurations...')

  # Updates instructor information
  update_instructor(data$`Instructor Name`, data$`Profile Picture`)
  # TODO: Updates repo links
  # update_repo_link(data$`Course Repo`)

  message(paste('\n\nHere is your Student Forms:', data$`Student Forms`))
  message('Head over to the link and restore the folder needed to store your responses.')
  Sys.sleep(3)
  message('Project successfully configured. You may close this RStudio session now if you want.')
  Sys.sleep(2)
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
  } else if (type == 'Google Spreadsheet') {
    df <- googlesheets4::read_sheet(spreadsheet)
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


# Determines if spread is an Excel file, CSV, or Google Spreadsheet
determine_spreadsheet <- function(spreadsheet) {
  if (endsWith(spreadsheet, ".csv")) return("csv")
  else if (endsWith(spreadsheet, ".xlsx")) return("xlsx")
  else if (grepl('google', spreadsheet, fixed = TRUE)) return("Google Spreadsheet")
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

# Get google drive ID
get_drive_id <- function(link) {
  return(strsplit(link, 'id?=')[[1]][2])
}

# Get github pages link
get_github_pages_link <- function(repo) {
  split <- strsplit(repo, "/+")[[1]]

  # Github.io repo
  if (grepl(split[4], paste(split[3], '.github.io', sep = ''), fixed = TRUE)) {
    return(paste(split[3], '.github.io', sep = ''))
  } else {
    return(paste(split[3], '.github.io/', split[4], sep = ''))
  }
}
