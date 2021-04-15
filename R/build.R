#' Builds all blog posts
#'
#' Builds all drafted blog posts for a DACSS course site.
#' The index page listing posts will be updated once
#' the Distill blog is built. Assumes a DACSS blog R project
#' is being used.
#'
#' @export
build_all_posts <- function() {
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

  preview_site('Success! Posts rendered successfully.')
}


#' Builds all student pages
#'
#' Builds all student pages for a DACSS course site.
#' Assumes the working directory is the GitHub repo
#' project file.
#' @export
build_student_pages <- function() {
  # Get path for all users
  all_pages <- list.files('users', '*.Rmd', recursive = TRUE)
  # Get users without path
  users <- sub('users/', '', all_pages)

  # No pages found
  if (identical(all_pages, character(0))) stop('No pages found!')

  # Iterates through each page
  for (user in users) {
    # Move files to root
    move_files(source_path = './users', source_file = user)
  }

  message('Building files... Please wait...')
  # Rename students (ignores)
  move_files(source_file = 'students.Rmd', dest_file = '_students.Rmd')
  # Builds entire site (except for students)
  rmarkdown::render_site(quiet = TRUE)
  # Rename students back
  move_files(source_file = '_students.Rmd', dest_file = 'students.Rmd')

  # Moves files back to user folder
  for (user in users) {
    move_files(source_file = user, dest_path = './users')
  }

  # Render students page
  rmarkdown::render_site(input = 'students.Rmd', quiet = TRUE)

  preview_site('Success! Student pages rendered successfully.')
}
