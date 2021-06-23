# DOCUMENTATION
## Contents
- [Prerequisites](#prerequisites)
- [Git and RStudio Setup](#git-and-rstudio-setup)
- [Installation](#installation)
  - [Install distill](#install-distill)
  - [Install postcards](#install-postcards)
  - [Install devtools](#install-devtools)
  - [Install blogbuilder](#install-blogbuilder)
- [Setup a new DACSS Course Blog](#setup-a-new-dacss-course-blog)
- [Create Student Pages](#create-student-pages)
- [Build Student Pages](#build-student-pages)
- [Build All Posts](#build-all-posts)
- [Update](#update)
  - [Update Course Title](#update-course-title)
  - [Update Course Semester](#update-course-semester)
  - [Update Course Instructor](#update-course-instructor)
- [Get Student Form](#get-student-form)
- [Reset](#reset)
  - [Reset Project Environment](#reset-project-environment)
- [Exclude](#exclude)
  - [Exclude Directory](#exclude-directory)
  - [Exclude File](#exclude-file)
- [Instructor Workflow](#instructor-workflow)

## Prerequisites
*Note*: You can see [Git and RStudio Setup](#git-and-rstudio-setup) if you have never used Github with RStudio and satisfy all the prerequisites mentioned here.    

- This package requires you to have [Git](https://git-scm.com/) configured on your computer.
- You are required to have a [Github](https://github.com/) account.
- You need to know the basics of git with RStudio.
- _Optional_: We recommend using [RStudio](https://www.rstudio.com/products/rstudio/) and assume that you already have it installed.


## Git and RStudio Setup
- You may see this [article](https://rfortherestofus.com/2021/02/how-to-use-git-github-with-r/) or utilize the following video:

  [![Git Guide](https://i.imgur.com/Py9palp.png)](https://youtu.be/pqWiwcfFz28?list=PL6fG9co6nK8ebkhWSS11z9MWKzRdoqzoTs "Git Guide")
  
- Learn the basics of Github with RStudio [here](https://youtu.be/we6m-B0ioFk).


## Installation
Note: This is a first time task only and you may skip this part if you have the packages mentioned below already installed.


#### Install distill
[Distill](https://rstudio.github.io/distill/) will enable you to make posts to the blog.
``` r
install.packages('distill')
```


#### Install postcards
[postcards](https://github.com/seankross/postcards) will enable you to create a personalized 'About Me' page for the blog.
``` r
install.packages('postcards')
```


#### Install devtools
[devtools](https://www.r-project.org/nosvn/pandoc/devtools.html) is used to manage packages. We will be using it to install the blogbuilder package.
``` r
install.packages("devtools")
```

#### Install blogbuilder
[blogbuilder](https://github.com/DACSS/blogbuilder) is used to manage the course blog as a whole. This is the package instructors will be primarily working with.
You can install this package through the devtools package we just installed:

``` r
devtools::install_github('DACSS/blogbuilder')
```


## Setup a new DACSS Course Blog
Run the following command in the Rstudio console:

``` r
blogbuilder::create_course_blog()
```
Then, simply follow the instructions displayed in the console to make a new course blog.


## Create Student Pages
Create 'About Me' pages for the students based on the provided .xlsx or .csv file.
```r
blogbuilder::create_student_pages(spreadsheet = 'path/to/students.csv', names_col = 1)

```

Running the example above reads in a spreadsheet called 'students.csv' and the student names is directed to be in the first column of the spreadsheet. 

This function takes in multiple arguments:

- spreadsheet (required): The path to the spreadsheet. CSV and xlsx formats are accepted.
- names_col (required): *Column number* or *name of the column* (eg. 'Name') are accepted.
- theme: The postcards theme. The default value is 'jolla'. More information on themes can be found here on [the package's page](https://github.com/seankross/postcards#the-templates).
- ... : Additional arguments arguments based on the arguments for read_csv or read_xlsx are accepted. For example:

``` r
blogbuilder::create_student_pages(spreadsheet = 'path/to/students.xlsx', 
                                    names_col = 'name', 
                                    sheet = 'data')
```

The example above reads in the student names from the column name, 'name', in the sheet 'data' from 'students.xlsx' file in the 'path/to/' directory rooted in the course folder.


## Build Student Pages
Build all student pages with the command:
``` r
blogbuilder::build_student_pages()
```
This command renders all the student pages (ie. builds HTML files from the RMarkdown student pages) so it is to be run everytime any changes are made to any of the student pages (or if new student pages are added).


## Build All Posts
Build all the drafted blog posts with the command:
```r
blogbuilder::build_all_posts()
```
This command renders all the student posts so it is to be run everytime new posts are added (or changes are made to existing posts).
_Note_: Run this command only after you are satisfied with all the student posts.


## Update
You can update various elements of the blog through the following commands.

#### Update Course Title
```r
blogbuilder::update_course_title('New Title')
```

#### Update Course Semester
```r
blogbuilder::update_course_semester('New Semester')
```

#### Update Course Instructor
```r
blogbuilder::update_course_instructor('New Instructor Name')
```
Arguments:  
```name```: The name to replace the current instructor name with.  
_Optional_:  ```prof_pic```: Link to your new profile picture.


## Get Student Form
Get student form link with the command:
```r
blogbuilder::get_student_form()
```


## Reset
#### Reset Project Environment
In the scenario the project environment is messed up, you may reset it with the following command:

``` r
blogbuilder::reset_project_env()
```


## Exclude
Enables you to exclude files and directories from your github repo.

#### Exclude Directory
``` r
blogbuilder::exclude_dir('/path/to/dir')
```

#### Exclude File
``` r
blogbuilder::exclude_file('/path/to/file')
```

## Instructor Workflow
- Read and follow all the instructions in this documentation while scrolling down from [prerequisites](#prerequisites) to [building posts](#build-all-posts) (inclusive).
- After setting up a course blog, you have access to all the RMarkdown files which you can manually edit to reflect changes in the blog.
- Once you have all the edits in place, you need to push the changes to the remote Github repository. Note: If you have no experience with Github, we have a great resource [here](https://youtu.be/we6m-B0ioFk) that we encourage you to use.
- Now, you need to publish the website on [Github Pages](https://pages.github.com/) to make it available for everyone to see. Follow through the directions below to achieve that:
  - Go to the course repository on Github and open settings.

  ![GIT-1](https://i.imgur.com/qxJWZvU.png)  
  
  - Press on the `Pages` tab.  

  ![GIT-2](https://i.imgur.com/Js60plT.png)  
  
  - Then follow the steps below:  

  ![GIT-1](https://i.imgur.com/DVmzcgP.png)  
  
  ![GIT-4](https://i.imgur.com/lkU3BIw.png)  
  
  - You should be all set up and get a screen like this:  
 
  ![GIT-5](https://i.imgur.com/qKHA23y.png)  
  
  - Press the link to check the course blog and see if everything is as you wished it to be.  

  _Note_: This is a one-time process. From now on, everytime you push any changes to the Github repository, the course blog will reflelect those changes automatically.  

- Lastly, feel free to check out all the functions mentioned in this documentation. While they are not necesarry to set up the blog, some of them may come in handy for certain auxiliary tasks or in case you are met with an error at some point of the process.
