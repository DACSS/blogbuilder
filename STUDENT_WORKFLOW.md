# Workflow (for Students)
- [Prerequisites](#prerequisites)
- [Git and RStudio Setup](#git-and-rstudio-setup)
- [Forking the Repository](#forking-the-repository)
- [R Package Requirements](#r-package-requirements)
- [Toggle to Student Mode](#toggle-to-student-mode)
- [Create a New Post](#creating-a-new-post-with-distill)
- [Create an About Me Page](#creating-an-about-me-page-with-postcards)
- [Making a Pull Request](#making-a-pull-request-to-the-main-repo)

## Prerequisites
Note: You can see [Git and RStudio Setup](#git-and-rstudio-setup) to satisfy all the following prerequisites:
- This package requires you to have [Git](https://git-scm.com/) configured on your computer.
- You are required to have a [Github](https://github.com/) account.
- You need to know the basics of git with RStudio.
- _Optional_: We recommend using [RStudio](https://www.rstudio.com/products/rstudio/) and assume that you already have it installed.


## Git and RStudio Setup
- You may see this [article](https://rfortherestofus.com/2021/02/how-to-use-git-github-with-r/) or utilize the following video:

  [![Git Guide](https://i.imgur.com/Py9palp.png)](https://youtu.be/pqWiwcfFz28?list=PL6fG9co6nK8ebkhWSS11z9MWKzRdoqzoTs "Git Guide")
  
- Learn the basics of Github with RStudio [here](https://youtu.be/we6m-B0ioFk).

## Forking the Repository

First you will need to fork the repository. You can do that by clicking the `Fork` icon on the top right corner of the course repo page.

![fork](https://raw.githubusercontent.com/DACSS/course_blog_template/main/_guide/images/fork.png)

If prompted to choose a user, choose your main GitHub account.

After you have forked the repo, you will have your 'own' version of the repo page to edit and any changes made to this repo will not affect the main course blog repo. Before heading over to RStudio and making changes, make sure to clone the repo by using the repo HTTP link with a new RStudio project.

## R Package Requirements

You will need to have the `devtools`, `blogbuilder`, `distill` and `postcards` packages first.
- [devtools](https://www.r-project.org/nosvn/pandoc/devtools.html) is used to manage packages. We will be using it to install the blogbuilder package.
- [blogbuilder](https://github.com/DACSS/blogbuilder) is used to manage the course blog as a whole. You will not be using much of this package as it was primarily built to provide instructors easy control over the course blog.
- [Distill](https://rstudio.github.io/distill/) will enable you to make posts to the blog.
- [Postcards](https://github.com/seankross/postcards) will enable you to create a personalized 'About Me' page for the blog.

Make sure you install the packages with `install.packages` and `devtools` with the commands below:

``` r
install.packages('devtools')
devtools::install_github('DACSS/blogbuilder')
devtools::install_github("rstudio/distill")
install.packages('postcards')
```

And load the libraries before proceeding further:

``` r
library(blogbuilder)
library(distill)
library(postcards)
```


## Toggle to Student Mode

You are required to toggle to student mode so as to prevent future merge conflicts on the instructor's side.

You may easily do this with the following command:

``` r
blogbuilder::iamstudent()
```

This command needs to be run everytime you pull changes from the Github repository.


## Creating a New Post with Distill

You can create a post by using the `create_post` function from Distill. It takes in [multiple arguments](https://rdrr.io/cran/distill/man/create_post.html), with `title` being required. It is also required to utilize `draft = TRUE`; this ensures that the posts you create does not update the entire site.

For example I can do:

``` r
distill::create_post(title = 'iris', author = "Your Name", draft = TRUE)
```

The command will automatically generate an R Markdown file for you to edit and use as a template for your post. Now, you can edit the file to your liking.

Note: I would recommend updating the header description and add categories:

![iris](https://raw.githubusercontent.com/DACSS/course_blog_template/main/_guide/images/iris.png)

Categories will be important as it's content will be used as labels for posts. This will become apparent later on. 

Once you are done, simply knit the file as a `distill_article`.

![knit](https://raw.githubusercontent.com/DACSS/course_blog_template/main/_guide/images/knit.png)

You will recieve an output preview of what your post will look like.

Once you are done, commit and push your changes to your repo.

## Creating an About Me Page with Postcards

You can create an About Me page by using the `create_postcard` function. If your instructor has already created a page for you, you may skip this step.

Here are [examples](https://github.com/seankross/postcards#the-templates) of themes you can use.

``` r
# Four different themes you can use. Choose only one!
postcards::create_postcard(file = 'users/[your_name].Rmd', template = "jolla")

postcards::create_postcard(file = 'users/[your_name].Rmd', template = "jolla-blue")

postcards::create_postcard(file = 'users/[your_name].Rmd', template = "trestles")

postcards::create_postcard(file = 'users/[your_name].Rmd', template = "onofre")
```

Choose one from the commands above. Make sure to replace `[your_name]` with your name (without the square brackets surrounding it).

For example:
```r
postcards::create_postcard(file = 'users/Hans Qiogue.Rmd', template = "jolla")
```

A file will be generated for your about page. Be sure to edit the page to your liking. You may view what your page looks like by knitting the page as `postcards`.

I would recommend storing your images in the `images` folder for consistency.

![postcards](https://raw.githubusercontent.com/DACSS/course_blog_template/main/_guide/images/postcards.png)

Like before, once you are done, commit and push all the new generated and modified files to your repo.

## Making a Pull Request to the Main Repo

Once you are done with everything, you may submit a pull request to the main repo. Head over the [repo page](https://github.com/DACSS/dacss_course_website) and click the `Pull requests` button.

![pr](https://raw.githubusercontent.com/DACSS/course_blog_template/main/_guide/images/pr.png)

Then when your on the next page, click the green `New pull request` button. Afterwards, click the blue `compare accross forks` link.

![compare](https://raw.githubusercontent.com/DACSS/course_blog_template/main/_guide/images/compare.png)

Edit the head repository **to your repo.**

![head](https://raw.githubusercontent.com/DACSS/course_blog_template/main/_guide/images/head.png)

Once you've done that, create a new pull request.

![new pr](https://raw.githubusercontent.com/DACSS/course_blog_template/main/_guide/images/new_pr.png)

Add some comments on what this pull request does. For example, in mine I added a new post about the iris dataset and created my about me page. Once you're done click the `Create pull request` button.

That's it! Wait for the instructor to review your pull request. They will give you feedback and if they approve your request, all your changes will be reflected on the main repo and website!
