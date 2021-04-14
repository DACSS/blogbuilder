# Creates a new R project from a GitHub repo
create_dacss_proj <- function(repo_link, directory) {
  if (length(directory) == 0L) {
    stop('Directory is invalid.')
  # Creates new R project based on user repo
  } else {
    usethis::create_from_github(
      repo_link,
      destdir = directory,
      fork = FALSE,
      rstudio = TRUE,
      open = TRUE
    )
  }
}

# Allows user input in selecting a directory
directory_input <- function() {
  cat('Please choose a directory you would like to store the new R project.\n\n')
  Sys.sleep(1)
  directory <- easycsv::choose_dir()
  return(directory)
}

# Updates YAML headers programmatically
# Original code by @r2evans: https://stackoverflow.com/users/3358272/r2evans
change_yaml_matter <- function(input_file, ..., output_file) {
  input_lines <- readLines(input_file)
  delimiters <- grep("^---\\s*$", input_lines)
  if (!length(delimiters)) {
    stop("unable to find yaml delimiters")
  } else if (length(delimiters) == 1L) {
    if (delimiters[1] == 1L) {
      stop("cannot find second delimiter, first is on line 1")
    } else {
      # found just one set, assume it is *closing* the yaml matter;
      # fake a preceding line of delimiter
      delimiters <- c(0L, delimiters[1])
    }
  }
  delimiters <- delimiters[1:2]
  yaml_list <- yaml::yaml.load(input_lines[(delimiters[1]+1):(delimiters[2]-1)])

  dots <- list(...)
  yaml_list <- c(yaml_list[setdiff(names(yaml_list), names(dots))], dots)

  output_lines <- c(
    if (delimiters[1] > 0) input_lines[1:(delimiters[1])],
    strsplit(yaml::as.yaml(yaml_list), "\n")[[1]],
    input_lines[-(1:(delimiters[2]-1))]
  )

  if (missing(output_file)) {
    return(output_lines)
  } else {
    writeLines(output_lines, con = output_file)
    return(invisible(output_lines))
  }
}

# Import spreadsheet of student names
import_spreadsheet <- function(spreadsheet, names_col, ...) {
  type <- determine_spreadsheet(spreadsheet)
  names <- NULL

  message(paste(type, 'format detected.'))

  # Reads in data based on file types
  if (type == 'csv') {
    df <- readr::read_csv(spreadsheet, ...)
  } else if (type ==  'xlsx') {
    df <- readxl::read_xlsx(spreadsheet, ...)
  }
  else stop(paste(type, 'is not a supported file type.'))

  if (is.null(df)) stop('An error has occured with the spreadsheet.')
  if (!(names_col %in% colnames(df)) & typeof(names_col) == 'character') {
    stop(paste(names_col, 'does not exist in the DataFrame.'))
  }

  # Vector of student names
  names <- df[[names_col]]

  return(names)
}


# Determines if spread is an Excel file or CSV
determine_spreadsheet <- function(spreadsheet) {
  if (endsWith(spreadsheet, ".csv")) return("csv")
  else if (endsWith(spreadsheet, ".xlsx")) return("xlsx")
  else return(NULL)
}

# Move files to different directories
move_files <- function(source_path = '.', dest_path = '.',
                       source_file, dest_file = source_file) {

  file.rename(from = file.path(source_path, source_file),
              to = file.path(dest_path, dest_file))
}

# Previews site after a build
preview_site <- function(success_message) {
  message(success_message)
  # Opens up index html (homepage) in browser
  utils::browseURL(paste('file://', file.path(getwd(), '/docs/index.html'), sep = ''))
}
