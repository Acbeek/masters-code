# My Project For Setting Up Your Cleaned Survey Database 

This project code is designd to handle specific database (rows and collunms), but might still be of use for quick cleaning and setting up. 
It is also aimed to help with a with a optimal research workflow.

## Usage

Click "Use this template" at the top of this page to create a new repository with the same folder structure.
***Also make a new R- workspace and save it in the main folder (the folder above docs, data, results.....etc***)

# Packages

install.packages("renv")
followed by

use renv::restore()

- brew         [* -> 1.0-10]
- callr        [* -> 3.7.6]
- cli          [* -> 3.6.5]
- commonmark   [* -> 2.0.0]
- cpp11        [* -> 0.5.3]
- desc         [* -> 1.4.3]
- docstring    [* -> 1.0.0]
- evaluate     [* -> 1.0.5]
- fs           [* -> 1.6.6]
- glue         [* -> 1.8.0]
- highr        [* -> 0.11]
- knitr        [* -> 1.51]
- lifecycle    [* -> 1.0.5]
- magrittr     [* -> 2.0.4]
- pkgbuild     [* -> 1.4.8]
- pkgload      [* -> 1.5.0]
- processx     [* -> 3.8.6]
- ps           [* -> 1.9.1]
- purrr        [* -> 1.2.1]
- R6           [* -> 2.6.1]
- renv         [* -> 1.1.7]
- rlang        [* -> 1.1.7]
- roxygen2     [* -> 7.3.3]
- rprojroot    [* -> 2.1.1]
- stringi      [* -> 1.8.7]
- stringr      [* -> 1.6.0]
- vctrs        [* -> 0.7.1]
- withr        [* -> 3.0.2]
- xfun         [* -> 0.56]
- xml2         [* -> 1.5.2]
- yaml         [* -> 2.3.12]

The version of R recorded in the lockfile will be updated:
- R            [* -> 4.5.2]


## Project Structure

The project structure distinguishes three kinds of folders:
- read-only (RO): not edited by either code or researcher
- human-writeable (HW): edited by the researcher only.
- project-generated (PG): folders generated when running the code; these folders can be deleted or emptied and will be completely reconstituted as the project is run.


```
.
├── .gitignore
├── CITATION.cff
├── LICENSE
├── README.md
├── requirements.txt
|── renv.lock          <- The repository of R
├── data               <- All project data, ignored by git
│   ├── cleandata      <- The final, canonical data sets for analysis (PG)
│   ├── raw 
|   |    |_________synthetic   <- synthethic made data for test purposes (RO) 
|   |                              consists of 3 smaller portion survey and 
|   |                              assessment datatbases.  
│   └── processed           <- Intermediate data that has been transformed. (PG)
├── docs               <- Documentation notebook for users (HW)
│   ├── manuscript     <- Here you can put your Manuscript source, e.g., 
|   |                     LaTeX, Markdown, etc. (HW)   
│   └── reports        <- Other project reports and notebooks (e.g. Jupyter, .Rmd) (HW)
├── results
│   ├── figures        <- Figures for the manuscript or reports (PG)
│   └── output         <- Other output for the manuscript or reports (PG)
└── R                  <- Source code for this project (HW)
    |____scr.          <- Scripts here you find the R test script

```

## License

This project is licensed under the terms of the [MIT License](/LICENSE).
