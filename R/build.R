#' Builds all blog posts
#'
#' Builds all drafted blog posts for a DACSS course site.
#' The index page listing posts will be updated once
#' the Distill blog is built. Assumes a DACSS blog R project
#' is being used.
#'
#' @export
build_all_posts <- function() {
  correct_env()

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


#' Build latest blog posts
#'
#' Render the posts added or modified in the most recent git pull.
#' Recommended use is only after git pull. In other cases and for a foolproof rendering of posts, consider using build_all_posts().
#'
#' @export
build_lates_posts <- function() {
  correct_env()

  file_names <- list.files('_posts', '*.Rmd', recursive = TRUE, full.names=TRUE) # Find file paths/names
  df <- file.info(file_names)   # Get info for the file paths - we want mtime from this ie. last modified
  max_date <- max(df$mtime)     # We find the last modified post and take it as the standard timestamp for the latest posts

  for (row in 1:nrow(df)) {     # Loop through the dataframe

    # message(paste(file_names[row], difftime(max_date, df[[row, 'mtime']])))

    if (difftime(max_date, df[[row, 'mtime']]) < 1) {     # Even the latest modified files have a difference of 0.0001 seconds at least so we take all the files which have time stamps less than 1 second away from the latest modified file's timestamp
      # similar to build_all_posts() - renders all posts whose file paths we provide
      post <- file_names[row]
      change_yaml_matter(post, draft = FALSE, output_file = post)
      rmarkdown::render(post, quiet = TRUE)
      message(paste(post, 'rendered.'))
      change_yaml_matter(post, draft = TRUE, output_file = post)
    }
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
  correct_env()

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
