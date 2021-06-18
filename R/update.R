#' Update course title
#'
#' Update course title in the homepage.
#'
#' @param title The title to replace the current course title with.
#' @export
update_course_title <- function(title) {
  correct_env()
  update_env_template('COURSE_TITLE', title)
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
#' @param name The name to replace the current course name with.
#' @param prof_pic To replace profile pic. Optional.
#' @export
update_course_instructor <- function(name, prof_pic = c()) {
  # Update instructor name
  update_env_template('INSTRUCTOR_NAME', name)
  change_yaml_matter('instructor.Rmd', title = name, output_file = 'instructor.Rmd')

  # Update instructor profile picture if inputted
  if (length(prof_pic)) {
    update_env_template('INSTRUCTOR_PROF_PIC', prof_pic)
    base_url <- 'https://drive.google.com/uc?export=view&id='
    picture <- paste(base_url, get_drive_id(prof_pic), sep = '')
    change_yaml_matter('instructor.Rmd', image = picture, output_file = 'instructor.Rmd')
  }
}
