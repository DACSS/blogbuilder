# DOCUMENTATION

- [Prerequisites](#prerequisites)
- [Git and RStudio Setup](#git-and-rstudio-setup)
- [Installation](#installation)
  - [Install devtools](#install-devtools)
  - [Install blogbuilder](#install-blogbuilder)
 - [Setup a DACSS Course Blog](#setup-a-DACSS-course-blog)

## Prerequisites
Note: You can see [Git and RStudio Setup](#git-+-rstudio-setup) to satisfy all the following prerequisites:
- This package requires you to have [Git](https://git-scm.com/) configured on your computer.
- You are required to have a [Github](https://github.com/) account.
- _Optional_: We recommend using [RStudio](https://www.rstudio.com/products/rstudio/) and assume that you already have it installed.

## Git and RStudio Setup
- You may utilize the following video:

  [![Git Guide](https://i.imgur.com/Py9palp.png)](https://youtu.be/pqWiwcfFz28?list=PL6fG9co6nK8ebkhWSS11z9MWKzRdoqzoTs "Git Guide")
  
  OR
- Check out this [article](https://rfortherestofus.com/2021/02/how-to-use-git-github-with-r/) with a different set of steps for the same task.

## Installation
Note: This is a first time task only and you may skip this part if you have devtools and blogbuilder alreadyy installed.

#### Install devtools

``` r
install.packages("devtools")
```

#### Install blogbuilder
You can install this package through the devtools package, we just installed:

``` r
devtools::install_github('DACSS/blogbuilder')
```

## Setup a DACSS Course Blog
Run the following command in the Rstudio console to generate a new course blog:

``` r
blogbuilder::create_course_blog()
```
Then, simply follow the instructions displayed in the console to make a new course blog.
