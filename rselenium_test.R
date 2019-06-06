# install.packages("RSelenium", repos = "http://cran.stat.ucla.edu/")
library(RSelenium)
library(png)
library(stringr)
library(tidyverse)
rm(list = ls())
rd <- remoteDriver(remoteServerAddr = "127.0.0.1",
                   port = 4445,
                   browserName = "chrome")
tryCatch(
  expr = {rd$getStatus();TRUE},
  error = function(e){FALSE}
) -> server_up
if (server_up) {
  page_to_scrape <- "http://www.google.com"
  rd$open(silent = TRUE)
  rd$navigate(page_to_scrape)
  page <- rd$getTitle()[[1]]
  timestamp <- Sys.time()
  if (!dir.exists("screenshots")) {
    dir.create("screenshots")
  }
  filename <- paste0("screenshots/", page, "_", timestamp, ".png")
  rd$screenshot(file = chartr(" :", "_-", filename))
  last_shot <- dplyr::last(dir(pattern = "*.png", recursive = TRUE))
  img <- png::readPNG(last_shot)
  grid::grid.raster(img)
  rd$close()
}

