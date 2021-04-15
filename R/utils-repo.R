generate_repo <- function() {
  cat('Redirecting to blog template on GitHub...\n')
  Sys.sleep(1)

  cat('When you have generated the repo, please copy the repo link.\n')
  Sys.sleep(1)

  # Opens browser to GitHub blog template link
  utils::browseURL('https://github.com/DACSS/dacss_course_website/generate')
}

check_repo_syntax <- function(link) {
  syntax <- grep("^(http|https)://github.com/([A-Za-z0-9]+)/([A-Za-z0-9]+)", link)

  # GitHub link is not valid
  if (is.integer(syntax) && length(syntax) == 0L) {
    stop(paste(link, 'is not a valid GitHub link'))
  }
}

# Line exists in .gitignore
line_exists <- function(path, func) {
  if (func(path)) {
    return(!identical(grep(path, readLines('.gitignore')), integer(0)))
  } else {
    stop(paste(path, 'does not exist.'))
  }
}
