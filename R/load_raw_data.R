#' Download Open Case Study Raw Data
#'
#' Download the specified case study raw data to use as you follow along the case study.
#'
#' @details This function downloads the Open Case Study raw data
#' from GitHub and saves it in a new 'data/raw/' folder in
#' the specified directory. This makes it so all the raw data
#' are easily available in a local folder to be processed and wrangled.
#'
#' @param casestudy character string, name of the case study to pull data from.
#' The input name should follow the same naming scheme as the repository on GitHub:
#'
#' ocs-bp-rural-and-urban-obesity
#'
#' ocs-bp-air-pollution
#'
#' ocs-bp-vaping-case-study
#'
#' ocs-bp-opioid-rural-urban
#'
#' ocs-bp-RTC-wrangling
#'
#' ocs-bp-RTC-analysis
#'
#' ocs-bp-youth-disconnection
#'
#' ocs-bp-youth-mental-health
#'
#' ocs-bp-school-shootings-dashboard
#'
#' ocs-bp-co2-emissions
#'
#' ocs-bp-diet
#'
#' @param outpath character string, path to the directory where the downloaded
#' data folder should be saved.
#'
#' @return Nothing useful is returned, a data/raw folder will be downloaded and
#' appear in your directory.
#'
#' @import httr
#' @importFrom purrr map
#' @export
#'
#' @examples load_raw_data('ocs-bp-co2-emissions', outpath = tempdir())
#'
load_raw_data <- function(casestudy, outpath = NULL){
  if (is.null(outpath)) {
    outpath = getwd() # path to working directory
  }
  datapath = file.path(outpath,'data') # path to new data folder directory
  dir.create(datapath, showWarnings = FALSE) # creating data folder

  rawpath = file.path(datapath,'raw') # path to raw data subfolder
  dir.create(rawpath, showWarnings = FALSE)

  # getting repo webpage data
  repo_url = paste0("https://api.github.com/repos/opencasestudies/",
                    casestudy, "/git/trees/master?recursive=1") # creating repo url string
  repo = GET(url=repo_url)
  repocont = content(repo)
  repounlist = unlist(repocont, recursive = FALSE)
  paths = map(repounlist,'path') # creating list of just the file paths in the repo
  paths = paths[!sapply(paths,is.null)] # removing null values

  for (fname in paths){
    if (grepl('data/', fname, fixed = TRUE)) { # if file is in the data directory
      if (grepl('/raw/', fname, fixed = TRUE)) { # if in raw
        if (grepl('.', fname, fixed = TRUE)) { # if a file name

          githuburl = paste0('https://github.com/opencasestudies/', casestudy, '/blob/master/',fname,'?raw=true') # github file link

          # download the file
          GET(githuburl, write_disk(file.path(outpath, fname))) # loading file from url and writing to disk

        } else { # if a directory name
          # create sub-folder
          subpath = file.path(outpath, fname)
          dir.create(subpath)

        }
      }
    }
  }
}

