#' Render all blog posts
#'
#' Renders all drafted blog posts for a DACSS course site.
#' The index page listing posts will be updated once
#' the Distill blog is built. Assumes a DACSS blog R project
#' is being used.
#'
#' @export
render_all_posts <- function() {
  all_post_files <- list.files('_posts', '*.Rmd', recursive = TRUE)

  # No post files found
  if (identical(all_post_files, character(0))) stop('No posts found!')

  # Goes through each post
  for (post in all_post_files) {
    post <- paste('_posts/', post, sep = '')
    # Un-drafts a Rmd file
    change_yaml_matter(post, draft = FALSE, output_file = post)
    # Renders Rmd file into Distill article
    rmarkdown::render(post, quiet = TRUE)
    message(paste(post, 'rendered.'))
    # Drafts Rmd file again
    change_yaml_matter(post, draft = TRUE, output_file = post)
  }

  message('Success! Posts rendered successfully.')
  utils::browseURL(paste('file://', file.path(getwd(), '/docs/index.html'), sep = ''))
}

#' Renders all student pages
#'
#' Renders all student pages for a DACSS course site.
#' Assumes the working directory is the GitHub repo
#' project file.
#' @export
render_student_pages <- function() {
  # Get path for all users
  all_pages <- list.files('users', '*.Rmd', recursive = TRUE)
  # Get users without path
  users <- sub('users/', '', all_pages)

  # No pages found
  if (identical(all_pages, character(0))) stop('No pages found!')

  # Iterates through each page
  for (user in users) {
    # Move files to root
    file.rename(from = file.path('./users', user),
                to = file.path('.', user))
  }

  # Builds files
  message('Building files... Please wait...')
  # Rename students
  file.rename(from = file.path('.', 'students.Rmd'),
              to = file.path('.', '_students.Rmd'))

  rmarkdown::render_site(quiet = TRUE)

  # Rename students
  file.rename(from = file.path('.', '_students.Rmd'),
              to = file.path('.', 'students.Rmd'))

  # Moves files back to user folder
  for (user in users) {
    file.rename(from = file.path('.', user),
                to = file.path('./users', user))
  }

  rmarkdown::render_site(input = 'students.Rmd', quiet = TRUE)

  message('Success! Student pages rendered successfully.')
  utils::browseURL(paste('file://', file.path(getwd(), '/docs/index.html'), sep = ''))
}
