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
  env_val <- Sys.getenv('DACSS_COURSE_MGMT')

  if (nchar(env_val) > 0) {
    if (env_val != 'VALID') {
      stop('Project environment is invalid. Please reset with: `reset_project_env()`')
    }
  } else {
    stop('Project environment not found. Maybe the working directory is wrong?')
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
