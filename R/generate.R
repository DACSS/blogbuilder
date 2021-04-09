#' Generate a new DACSS blog
#'
#' Generates a new DACSS blog into a user-specified GitHub
#' repository. A generic DACSS blog will be
#' created with a Distill and Postcards setup. Assumes the user
#' has Git configured on their personal computer already.
#' The repo will be generated if it has not been setup already.
#' Simply follow the series of prompts when the function is called.
#'
#' @export
generate_dacss_blog <- function() {
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
