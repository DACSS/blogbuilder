# Documentation

- [Prerequisites](https://github.com/DACSS/blogbuilder/tree/main/man#prerequisites)
- [Initial Setup](https://github.com/DACSS/blogbuilder/tree/main/man#initial-setup)
- [Create and Build](https://github.com/DACSS/blogbuilder/tree/main/man#create-and-build)
    - [Post](https://github.com/DACSS/blogbuilder/tree/main/man#post)
    - [Student Pages](https://github.com/DACSS/blogbuilder/tree/main/man#student-pages)
- [Update](https://github.com/DACSS/blogbuilder/tree/main/man#update)
    - [Course Title](https://github.com/DACSS/blogbuilder/tree/main/man#course-title)
    - [Semester](https://github.com/DACSS/blogbuilder/tree/main/man#semester)
- [Exclude](https://github.com/DACSS/blogbuilder/tree/main/man#exclude)
    - [Docs Folder](https://github.com/DACSS/blogbuilder/tree/main/man#docs-folder)
    - [Directory](https://github.com/DACSS/blogbuilder/tree/main/man#directory)
    - [File](https://github.com/DACSS/blogbuilder/tree/main/man#file)
- [Get](https://github.com/DACSS/blogbuilder/tree/main/man#get)
    - [Student Forms](https://github.com/DACSS/blogbuilder/tree/main/man#student-forms)
- [Reset](https://github.com/DACSS/blogbuilder/tree/main/man#reset)
    - [Project Environment](https://github.com/DACSS/blogbuilder/tree/main/man#project-environment)

## Prerequisites

*Note that this package requires you to have Git configured on your computer.* You may utilize the following if you prefer watching a video version:

[![Git Guide](https://i.imgur.com/Py9palp.png)](https://youtu.be/pqWiwcfFz28?list=PL6fG9co6nK8ebkhWSS11z9MWKzRdoqzoTs "Git Guide")

Otherwise, if you prefer, you may read [Git's official guide](https://docs.github.com/en/github/getting-started-with-github/quickstart/set-up-git).

## Initial Setup

To generate a DACSS course blog, you can run the following command:

``` r
blogbuilder::create_dacss_blog()
```

Simply follow the instructions that display in the RStudio console.

## Create and Build

### Post

Students should be instructed to create `draft` posts—as in they need to run the following function when creating a post:

``` r
distill::create_post('TITLE OF POST', draft = TRUE)
```

**It is important that they have `draft = TRUE` when the post is initially created or `draft: yes` in the YAML header of the post itself:**

![draft](https://i.imgur.com/bEE2HTj.png)

---

Once you are satisfied with all student posts, you can render them and make them public (accessible through the homepage for example).

Run the following function to do so:

``` r
blogbuilder::build_all_posts()
```

When the function completes, you will recieve a preview of your site with all the posts displayed on the homepage. 

## Student Pages

To create student pages, you can import student names with the following command:

```
blogbuilder::create_student_pages(spreadsheet = 'path/to/students.csv', names_col = 1)
```

Running the example above reads in a spreadsheet called 'students.csv' and the student names is directed to be in the first column of the spreadsheet. 

The function takes in multiple arguments:

- spreadsheet (required): The path to the spread. CSV, xlsx, and Google Spreadsheet formats are accepted.
- names_col (required): An **integer of the index** of or a **string of the name of column** that contains the student names.
- theme: The postcards theme. The default value is 'jolla'. More information on themes can be found here on [the developer's page](https://github.com/seankross/postcards#the-templates).
- ... : Additional arguments can be passed in when reading in the data. For example:

``` r
blogbuilder::generate_student_pages(spreadsheet = 'path/to/students.xlsx', 
                                    names_col = 'name', 
                                    sheet = 'data')
```

The example above reads in the spreadsheet 'students.xlsx' in the sheet 'data', and student names is in the column 'name' of the spreadsheet.

---

Once students are done editing their pages, you can render them and make them accessible to the public—similar to how the post system works. 

You can do so by running the function:

``` r
blogbuilder::build_student_pages()
```

All student pages will be accessible through the Student page on the website.

## Update

You may update various parts of the site through the following functions.

### Course Title

``` r
blogbuilder::update_course_title('NAME OF NEW TITLE')
```

Arguments:
- title (required): the new course title

### Semester

``` r
blogbuilder::update_course_semester('NAME OF NEW SEMESTER') 
```

Arguments:
- semester (required): the new semester

## Exclude

**Students should be instructed to exclude the `docs` folder.** This will avoid site building issues for instructors and future merge conflicts on GitHub. 

### Docs Folder

``` r
blogbuilder::exclude_docs()
```

### Directory

``` r
blogbuilder::exclude_dir('/path/to/dir')
```

Arguments:
- path (required): the path to the folder to exclude

### File

``` r
blogbuilder::exclude_file('/path/to/file')
```

Arguments:
- path (required): the path to the file to exclude

## Get

### Student Forms

``` r
blogbuilder::get_student_form()
```

## Reset

### Project Environment

In the scenario the project environment is messed up, you may reset it with the following command:

``` r
blogbuilder::reset_project_env()
```