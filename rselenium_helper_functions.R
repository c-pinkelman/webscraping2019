ge_txt <- function(el){
  el$getElementText()[[1]]
}
ge_ref <- function(el){
  el$getElementAttribute("href")[[1]]
}
sapply(jobs, ge_txt)
sapply(jobs, ge_ref)
