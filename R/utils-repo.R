generate_repo <- function() {
  cat('Redirecting to blog template on GitHub...\n')
  Sys.sleep(1)

  cat('When you have generated the repo, please copy the repo link.\n')
  Sys.sleep(1)

  # Opens browser to GitHub blog template link
  utils::browseURL('https://github.com/DACSS/dacss_course_website/generate')
}

# Check gh status for a user
gh_status <- function() {
  message('Checking if your GitHub account is properly configured...')

  # PAT is not set
  if (identical(gitcreds::gitcreds_get(use_cache = FALSE)$password, '')) {
    message('GitHub token is not found. Creating a personal access token...')
    usethis::create_github_token()
    message('Displaying prompt to store your new token.')
    gitcreds::gitcreds_set()
    gh_status()
  } else {
    message('Your account is configured properly.')
  }
}

check_repo_syntax <- function(link) {
  syntax <- grep("^(http|https)://github.com/([A-Za-z0-9]+)/([A-Za-z0-9]+)", link)

  # GitHub link is not valid
  if (is.integer(syntax) && length(syntax) == 0L) {
    stop(paste(link, 'is not a valid GitHub link'))
  }
}

# Generate env file
initialize_env <- function(row) {
  file.create('.env')
  file_conn <- file('.env', 'a')

  write('DACSS_COURSE_MGMT = "VALID"', file_conn, append = TRUE)

  # All env variables to create
  envs <- c('COURSE_REPO', 'COURSE_TITLE', 'SEMESTER', 'INSTRUCTOR_NAME',
            'COURSE_DESC', 'SYLLABUS', 'INSTRUCTOR_DESC', 'INSTRUCTOR_PROF_PIC', 'INSTRUCTOR_LINKEDIN',
            'INSTRUCTOR_TWITTER', 'INSTRUCTOR_GITHUB', 'INSTRUCTOR_EMAIL', 'STUDENT_FORMS')

  # Links env variables and row data
  row <- row[, -1]
  for (i in 1:length(row)) {
    val <- retrieve_form_values(row, colnames(row)[i])
    write(paste(envs[i], ' = "', val, '"', sep = ''), file_conn, append = TRUE)
  }

  close(file_conn)
}

# Check if project environment is correct
correct_env <- function() {
  env_exists()
  env_val <- Sys.getenv('DACSS_COURSE_MGMT')

  if (nchar(env_val) > 0) {
    if (env_val != 'VALID') {
      stop('Project environment is invalid. Please reset with: `reset_project_env()`')
    }
  } else {
    stop('Project environment not found. Maybe the working directory is wrong?')
  }
}

# Line exists in .gitignore
line_exists <- function(path, func, file = '.gitignore', env = FALSE) {
  if (func(path) || env == TRUE) {
    return(!identical(grep(path, readLines(file)), integer(0)))
  } else {
    stop(paste(path, 'does not exist.'))
  }
}

# Check if env file exists. If it exists, the
# environment variables are read in
env_exists <- function() {
  # If .env exists, read in file
  line_exists('.env', file.exists)
  readRenviron('.env')
}
