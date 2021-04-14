# **dacss.websites**

An R package for DACSS courses made with [Distill](https://rstudio.github.io/distill/) and [Postcards](https://github.com/seankross/postcards).

## **Installation**

You can install this package through devtools:

``` r
devtools::install_github('DACSS/dacss.websites')
```

## **Getting Started**

## Initial Setup

To generate a DACSS course blog, you can run the following command:

``` r
dacss.websites::generate_dacss_blog()
```

Simply follow the instructions that display in the RStudio console.

## Posts

Prerequisites:

Students should be instructed to create `draft` posts—as in they need to run the following function when creating a post:

``` r
distill::create_post('TITLE OF POST', draft = TRUE)
```

**It is important that they have `draft = TRUE` when the post is initially created or `draft: yes` in the YAML header of the post itself:**

![draft](https://i.imgur.com/bEE2HTj.png)

They will also need to knit their documents after they are done writing their post. 

---

Once you are satisfied with their posts, you can render them and make them public (accessible through the homepage for example).

Run the following function to do so:

``` r
dacss.websites::render_all_posts()
```

When the function completes, you will recieve a preview of your site with all the posts displayed on the homepage. 

## Student Pages

To create student pages, you can import student names with the following command:

```
dacss.websites::generate_student_pages(spreadsheet = 'path/to/students.csv', names_col = 1)
```

Running the example above reads in a spreadsheet called 'students.csv' and the student names is directed to be in the first column of the spreadsheet. 

The function takes in multiple arguments:

- spreadsheet (required): The path to the spread. CSV and xlsx formats are accepted.
- names_col (required): An integer of the index of or a string of the name of column that contains the student names.
- theme: The postcards theme. The default value is 'jolla'. More information on themes can be found here on [the developer's page](https://github.com/seankross/postcards#the-templates).
- ... : Additional arguments can be passed in when reading in the data. For example:

``` r
dacss.websites::generate_student_pages(spreadsheet = 'path/to/students.xlsx', 
                                       names_col = 'name', sheet = 'data')
```

The example above reads in the spreadsheet 'students.xlsx' in the sheet 'data, and student names is in the column 'name' of the spreadsheet.

---

Once students are done editing their pages, you can render them and make them accessible to the public—similar to how the post system works. 

You can do so by running the function:

``` r
dacss.websites::render_student_pages()
```

All student pages will be accessible through the Student page on the website. 