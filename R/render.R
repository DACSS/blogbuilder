#' Render all blog posts
#'
#' Renders all drafted blog posts for a DACSS course site.
#' The index page listing posts will be updated once
#' the Distill blog is built. Assumes a DACSS blog R project
#' is being used.
#'
#' @importFrom rmarkdown render
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
    rmarkdown::render(post)
  }
}
