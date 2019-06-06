library(RSelenium)
rm(list = ls())
rd <- remoteDriver(
  remoteServerAddr = "127.0.0.1",
  port = 4445,
  browserName = "chrome"
)
tryCatch(
  expr = {
    rd$getStatus()
    TRUE
  },
  error = function(e) {
    FALSE
  }
) -> server_up
rd$open(silent = TRUE)
# Allow more time for the page to load.
rd$setTimeout(type = "page load", milliseconds = 10000)

page_to_scrape <- "https://www.glassdoor.com/Job/"
rd$navigate(page_to_scrape)
cn <- "m-0"
new_header <- "All your base are belong to us."
js_change_header <- paste0("document.getElementsByClassName(\"", cn , "\")[0].textContent = \"", new_header, "\";")
rd$executeScript(script = js_change_header, args = list(""))

js_add_link <- "var link = document.createElement('a');
var linkText = document.createTextNode('Click here for a good time!');
link.appendChild(linkText);
link.href = 'Job/jobs.htm?suggestCount=0&suggestChosen=false&clickSource=searchBtn&typedKeyword=&sc.keyword=&locT=&locId=&jobType='
link.id = 'cantstopmenow';
var head = document.getElementsByClassName('m-0')[0];
head.appendChild(link);"
rd$executeScript(script = js_add_link, args = list(""))

xp_screwyou <- "//*[@id=\"cantstopmenow\"]"
a_screw <- rd$findElement("xpath", xp_screwyou)
a_screw$clickElement()

#### Now we have available to us all of the all!

#### Let's go ahead learn where things are.
#### Remember, we'll need to find them again everytime the page changes.
xp_key <- "//*[@id=\"sc.keyword\"]"
xp_loc <- "//*[@id=\"sc.location\"]"
xp_btn_search <- "//*[@id=\"HeroSearchButton\"]"
txt_key <- rd$findElement("xpath", xp_key)
txt_loc <- rd$findElement("xpath", xp_loc)
btn_search <- rd$findElement("xpath", xp_btn_search)

#### Let's find all the statistics jobs in the United States.
#### As a general rule I always clear text before I enter text.
txt_key$clearElement()
txt_key$sendKeysToElement(list("Statistics"))
txt_loc$clearElement()
txt_loc$sendKeysToElement(list("United States", key = "enter"))

xp_listing <- "//*[@id=\"MainCol\"]/div[1]/ul/li"
xp_joblink <- "./div[2]/div[1]/div[1]/a"
listings <- rd$findElements("xpath", xp_listing)
process_listing <- function(node){
  job <- node$findChildElement("xpath", xp_joblink)
  job_title <- job$getElementText()[[1]]
  job_link <- job$getElementAttribute("href")[[1]]
  c(job_title, job_link)
}
job_page <- lapply(listings, process_listing)

# Get next button

# Pull URL

# Scrape 30 pages

# We now have 900 URLs

# Scrape each individual page


# https://www.glassdoor.com/Job/los-angeles-statistics-jobs-SRCH_IL.0,11_IC1146821_KE12,22_IP30.htm


# interstitial
# //*[@id="JAModal"]/div/div[2]/div/div[1]

# js_sel_date_enable <- "var seldate = document.querySelector(\"#DKFilters > div > div > div:nth-child(2)\");
# seldate.className = \"filter expanded\"" # expanded means we may not have to click it.
# rd$executeScript(script = js_sel_date_enable, args = list(""))



# xp_sel_date <- "//*[@id=\"DKFilters\"]/div/div/div[2]"
# sel_date <- rd$findElement("xpath", xp_sel_date)
# sel_date$clickElement()


# rd$findElement
# xp_key <- "//*[@id=\"sc.keyword\"]"
# xp_loc <- "//*[@id=\"sc.location\"]"
# xp_btn_search <- "//*[@id=\"HeroSearchButton\"]"
# txt_key <- rd$findElement("xpath", xp_key)
# txt_loc <- rd$findElement("xpath", xp_loc)
# btn_search <- rd$findElement("xpath", xp_btn_search)
# 
# txt_key$clearElement()
# txt_loc$clearElement()
# txt_loc$sendKeysToElement(list(key = "enter"))
# btn_search$clickElement()
