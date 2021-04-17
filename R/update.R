#' Update course title
#'
#' Update course title in the homepage.
#'
#' @param title The title to replace the current course title with.
#' @export
update_course_title <- function(title) {
  update_env_template('COURSE_TITLE', title)
}

#' Update course semester
#'
#' Update course semester in the homepage.
#' @param semester The semester to replace the current semester with.
#' @export
update_course_semester <- function(semester) {
  update_env_template('SEMESTER', semester)
}

# TODO: Documentation and export
update_instructor <- function(name, prof_pic = "NA") {
  # Update instructor name
  update_env_template('INSTRUCTOR_NAME', name)
  change_yaml_matter('instructor.Rmd', title = name, output_file = 'instructor.Rmd')

  # Update instructor profile picture
  if (prof_pic != "NA") {
    update_env_template('INSTRUCTOR_PROF_PIC', prof_pic)
    base_url <- 'https://drive.google.com/uc?export=view&id='
    picture <- paste(base_url, get_drive_id(prof_pic), sep = '')
    change_yaml_matter('instructor.Rmd', image = picture, output_file = 'instructor.Rmd')
  }
}

# TODO: Documentation and export
update_repo_link <- function(repo) {
  link <- get_github_pages_link(repo)
  change_yaml_matter('_site.yml', base_url = repo, output_file = '_site.yml')
  change_yaml_matter('_site.yml',
                     navbar = list(logo = list
                                  (image = 'images/UMass White Workmark Horiz.png',
                                   href = link)))
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
    line <- paste(env, " = '", env_val, "'", sep = '')
    new_line <- paste(env, " = '", new_val, "'", sep = '')
    update_env_file(line, new_line)
    message(paste('Success!', env, 'is now:', new_val))
  } else if (env_val == new_val) {
    message(paste(env, 'is already set to:', new_val))
  } else {
    stop(paste(env, 'does not exist.'))
  }
}

# Updates env file based on new line
update_env_file <- function(line, new_line) {
  new_file <- gsub(line, new_line, readLines('.env'))
  writeLines(new_file, con = '.env')
  readRenviron('.env')
}
