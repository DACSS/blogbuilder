generate_repo <- function() {
  cat('Redirecting to blog template on GitHub...\n')
  Sys.sleep(1)

  cat('When you have generated the repo, please copy the repo link.\n')
  Sys.sleep(1)

  # Opens browser to GitHub blog template link
  utils::browseURL('https://github.com/DACSS/course_blog_template/generate')
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

# Line exists in .gitignore
line_exists <- function(path, func, file = '.gitignore', env = FALSE) {
  if (func(path) || env == TRUE) {
    return(!identical(grep(path, readLines(file)), integer(0)))
  } else {
    stop(paste(path, 'does not exist. Please update your working directory to the project repo.',
              'You may also use reset_project_env() to correct the project environment.'))
  }
}
