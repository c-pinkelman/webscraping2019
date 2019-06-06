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
page_to_scrape <- "http://www.google.com"
rd$navigate(page_to_scrape)
xp_search <- "//*[@id=\"tsf\"]/div[2]/div/div[1]/div/div[1]/input"
search_bar <- rd$findElement(using = "xpath", value = xp_search)
search_bar$sendKeysToElement(sendKeys = list("What is the meaning of life?"))
rd$screenshot(display = TRUE)
search_bar$clearElement()
rd$screenshot(display = TRUE)
search_bar$sendKeysToElement(sendKeys = list("What is the meaning of life?",
                                             key = "down_arrow",
                                             key = "enter"))
rd$screenshot(display = TRUE)
xp_arrow3 <- "//*/div[3]/g-accordion-expander/div"
arrow3 <- rd$findElement(using = "xpath", value = xp_arrow3)
arrow3$clickElement()
rd$screenshot(display = TRUE)
child <- arrow3$findChildElement(using = "xpath", value = "../div[2]/div/div/div/div/span")
ascii42 <- child$getElementText()[[1]]
writeLines(ascii42)
rd$close()
