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
  update_course_instructor(data$`Instructor Name`, data$`Profile Picture`)
  update_course_repo(data$`Course Repo`)

  message(paste('\nHere is your Student Forms:', data$`Student Forms`))
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
    googlesheets4::gs4_deauth()
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

# Generate env file
initialize_env <- function(row) {
  file.create('.env')
  file_conn <- file('.env', 'a')

  write('DACSS_COURSE_MGMT = "VALID"', file_conn, append = TRUE)

  # All env variables to create
  envs <- c('COURSE_REPO', 'COURSE_TITLE', 'SEMESTER', 'INSTRUCTOR_NAME',
            'INSTRUCTOR_PROF_PIC', 'STUDENT_FORMS')

  # Links env variables and row data
  row <- row[, -1]
  for (i in 1:length(row)) {
    val <- retrieve_form_values(row, colnames(row)[i])
    write(paste(envs[i], ' = \"', val, '\"', sep = ''), file_conn, append = TRUE)
  }

  close(file_conn)
}

# Check if project environment is correct
correct_env <- function() {
  env_exists()
  check_mode()
  env_val <- Sys.getenv('DACSS_COURSE_MGMT')

  if (nchar(env_val) > 0) {
    if (env_val != 'VALID') {
      stop('Project environment is invalid. Please reset with: `reset_project_env()`')
    }
  } else {
    stop('Project environment not found. Maybe the working directory is wrong?')
  }
}

# Check if project is in student or instructor mode
check_mode <- function() {
  lines <- readLines(".gitignore")
  if (length(lines) == 48) {
    message('Instructor Mode Pass...')
  }
  else {
    message('Project is currently in Student mode. If you are an instructor, please run blogbuilder::iaminstructor()')
  }
}

# Check if env file exists. If it exists, the
# environment variables are read in
env_exists <- function() {
  # If .env exists, read in file
  line_exists('.env', file.exists)
  readRenviron('.env')
}

# Updates file
update_env_template <- function(env, new_val) {
  if (typeof(new_val) != 'character') stop(paste(new_val, 'needs to be a string.'))

  # Checks if .env exists
  env_exists()
  # Reads in env
  env_val <- Sys.getenv(env)

  # Read in env line is not empty (it exists)
  if (nchar(env_val) > 0) {
    # Updates env based on new value
    line <- paste(env, ' = \"', env_val, '\"', sep = '')
    new_line <- paste(env, ' = \"', new_val, '\"', sep = '')
    update_env_file(line, new_line)
    message(paste('Success!', env, 'is now:', new_val))
  } else if (env_val == new_val) {
    message(paste(env, 'is already set to:', new_val))
  } else {
    stop(paste(env, 'does not exist.'))
  }
}

# Updates env file based on new line
update_env_file <- function(line, new_line, initial = TRUE) {
  new_file <- gsub(line, new_line, readLines('.env'))
  writeLines(new_file, con = '.env')
  readRenviron('.env')
}

# Store the URL for the google sheets linked to the form in local.txt file
store_posts_sheet <- function() {
  sheets_url <- readline('Please paste your posts URL sheets\' link and hit enter: ')
  fileConn<-file("local.txt")
  writeLines(sheets_url, fileConn)
  close(fileConn)
}

# Send email
send_email <- function(to_email, url) {
  # Compose email
  date_time <- blastula::add_readable_time()
  email <-
    blastula::compose_email(
      body = blastula::md(glue::glue(
"Hello,

Your post at {url} has been imported to DACSS 601 course blog.

Best, \n
Course Staff
")),
      footer = blastula::md(glue::glue("Email sent on {date_time}."))
    )

  creds <- rjson::fromJSON(file= "email_creds" )
  from_email <- creds$value[[5]]$value
  readRenviron(".env")
  course_title <- Sys.getenv('COURSE_TITLE')

  # Send email
    blastula::smtp_send(
      email = email,
      to = to_email,
      from = from_email,
      subject = paste('[', course_title, ']'),
      credentials = blastula::creds_file("email_creds")
    )
}

# Setup Email Creds
setup_email_creds <- function() {
  email <- readline('Please input your email: ')
  blastula::create_smtp_creds_file(file = "email_creds", user = email, provider = "gmail")
}

