#' Update course title
#'
#' Update course title in the homepage.
#'
#' @param title The title to replace the current course title with.
#' @export
update_course_title <- function(title) {
  correct_env()
  update_env_template('COURSE_TITLE', title)

  yml_content <- yaml::read_yaml('_site.yml')
  readRenviron('.env')
  yml_content[2] = Sys.getenv('COURSE_TITLE')
  yaml::write_yaml(yml_content, "_site.yml")
}

#' Update course semester
#'
#' Update course semester in the homepage.
#' @param semester The semester to replace the current semester with.
#' @export
update_course_semester <- function(semester) {
  correct_env()
  update_env_template('SEMESTER', semester)
}

#' Update Course Instructor name
#'
#' Update Course Instructor name in the homepage.
#'
#' @param name The name to replace the current instructor name with.
#' @param prof_pic To replace profile pic. Optional.
#' @export
update_course_instructor <- function(name, prof_pic = NULL) {
  # Update instructor name
  update_env_template('INSTRUCTOR_NAME', name)
  change_yaml_matter('instructor.Rmd', title = name, output_file = 'instructor.Rmd')

  # Update instructor profile picture if inputted
  if(!is.null(prof_pic)) {
    update_env_template('INSTRUCTOR_PROF_PIC', prof_pic)
    base_url <- 'https://drive.google.com/uc?export=view&id='
    picture <- paste(base_url, get_drive_id(prof_pic), sep = '')
    change_yaml_matter('instructor.Rmd', image = picture, output_file = 'instructor.Rmd')
  }
}


#' Update Course Repo Link
#'
#' Update Course Repo Link in the header.
#'
#' @param link The new repo link to replace the current repo link with.
#' @export
update_course_repo <- function(link = NULL) {
  if(!is.null(link))
    update_env_template('COURSE_REPO', link)

  # Updates the github repo (top right corner github icon's link) on the blog with the repo link of this course
  yml_content <- yaml::read_yaml('_site.yml')
  readRenviron('.env')
  yml_content$navbar$right[[4]]$href = Sys.getenv('COURSE_REPO')
  yaml::write_yaml(yml_content, "_site.yml")
}
