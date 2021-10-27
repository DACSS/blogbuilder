#' Builds a new DACSS blog
#'
#' Builds a new DACSS blog into a user-specified GitHub
#' repository. A generic DACSS blog will be
#' created with a Distill and Postcards setup. Checks if the user
#' has Git configured on their personal computer. The repo will be generated
#' if it has not been setup already. Also asks the user to authenticate their
#' Google account. Simply follow the series of prompts when the function is called.
#'
#' @export
create_course_blog <- function() {
  # Check if Git is configured properly
  gh_status()

  # Menu for repo template
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

  # Uses deauthenticated state (only need read access)
  googlesheets4::gs4_deauth()
  # Instructor form
  instructor_form()

  # Store the URL for the google sheets linked to the form in local.txt file
  store_posts_sheet()

  # User inputs directory path
  directory <- directory_input()
  repo_name <- strsplit(repo_link, "/+")[[1]][4] # [[1]][4] represents GitHub repo name
  repo_name <- strsplit(repo_name, ".", fixed=TRUE)[[1]][1]
  new_proj_path <- paste(directory, '/', repo_name, sep = '')

  # Choosen directory has folder that exists
  if (dir.exists(new_proj_path)) stop(paste(new_proj_path, 'already exists.'))

  # New project
  if (length(create_dacss_proj(repo_link, directory))) {
    setwd(new_proj_path)

    # Update course
    row <- retrieve_row(repo_link, initialize = TRUE)
    initialize_project(row[1:1, ])  #Selecting the first row
  }
}


#' Builds student postcards
#'
#' Builds 'about me' pages for students in a Postcards setup. A spreadsheet
#' of student information is taken as input -- with names as a primary
#' requirement. Csv, xlsx, and Google Spreadsheet formats are accepted.
#' It will also generate list of student names in the Student page.
#' Assumes the working directory is based on the GitHub blog repo prokect.
#'
#' @param spreadsheet A csv, xlsx, or Google Spreadsheet file containing student names.
#' @param names_col The column containing student names. Can be the column
#' name or number.
#' @param theme The template theme to create postcard pages with. The default
#' value is "jolla".
#' @param ... Additional arguments can be taken based on arguments for
#' read_csv or read_xlsx.
#' @export
create_student_pages <- function(spreadsheet, names_col, theme = "jolla", ...) {
  correct_env()

  names <- import_spreadsheet(spreadsheet, names_col, ...)

  for (name in names) {
    name <- gsub("[^[:alnum:]]", "-", name)
    file_name <- paste(name, '.Rmd', sep = '')
    message(paste(name, 'created'))

    # Create postcard R Markdown files for each student
    postcards::create_postcard(file = name, template = theme,
                               edit = FALSE, create_image = FALSE)
    # Move file to users folder
    move_files(source_file = file_name, dest_path = './users')
  }

  message('Success. Student files created.')
}



#' Create Lessons
#'
#' Creates lessons when the course tutorials' folder is provided in the root of the course repository.
#'
#' @export
create_lessons <- function() {
  content <- c()

  # Get all the *.dcf files which have the name and links to the shiny sites for the learnr tutorials
  dcf_files <- list.files(pattern = "\\.dcf$", recursive = TRUE)

  if (length(dcf_files) > 0) {
    for (path in dcf_files) {

      # Read the content in the file and get the url and name fields
      data <- read.dcf(path, fields = c('url','name'))
      name <- data[2]
      url <- data[1]

      # Make html embed files for all the tutorials
      html_content <- paste("<embed src=\"", url, "\" style=\"width:100%; height: 100%;\">", sep = "")
      html_file_name <- paste("docs/", name, ".html", sep = "")

      c <- file(html_file_name, "w")
      writeLines(html_content, c)
      close(c)

      # Add a new line (for the new shiny site) to the vector - content
      line <- paste('- [', name, '](', name, '.html', ')', sep = '')
      content <- c(content, line)

    }

    #Arrange content for the lessons.Rmd file
    yaml_header <- c("---", "title: \"Lessons\"" , "site: distill::distill_website", "---", "")
    rmd_file <- c(yaml_header, content)

    # Write the lessons.Rmd file
    fileConn <- file("lessons.Rmd", "w")
    writeLines(rmd_file, fileConn)
    close(fileConn)

    # Add lessons tab to the navbar
    yml_content <- yaml::read_yaml('_site.yml')
    if (yml_content$navbar$right[[4]][[1]] != "Lessons") {
      yml_content$navbar$right <- append(yml_content$navbar$right, list(list(text='Lessons', href = 'lessons.html')), 3)
      yaml::write_yaml(yml_content, "_site.yml")
      message("Lessons tab created!")
    } else {
      message("You alreaady have the lessons tab. Skipping this step...")
    }

    message('Succssfully created the lessons!')
  } else {
    message('Creating lessons unsuccessful! Please put the tutorials folder in the root directory and re-run this function.')
  }
}


