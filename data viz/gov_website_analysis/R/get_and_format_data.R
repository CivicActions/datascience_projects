# GET DATA

get_data <- function() {
    URL <- paste0("https://raw.githubusercontent.com/GSA/govt-urls/master/1_go",
                  "vt_urls_full.csv")
    not_gov <- read.csv(URL)
    
    names(not_gov) <- c("domain", "federal_agency", "gov_level", "location",
                        "status", "notes", "link")
    not_gov <- not_gov[, c("domain", "gov_level", "location")]
    
    URL <- paste0("https://raw.githubusercontent.com/cisagov/dotgov-data/main/",
                  "current-full.csv")
    gov <- read.csv(URL)
    
    gov <- gov[, c(1, 3, 6)]
    
    return(dat)
}

format_date <- function(dat) {
    library(lubridate)
    
    dat$Date.Added <- as_date(dat$Date.Added, format = "%m/%d/%y %H:%M")
    dat$subdom <- gsub("(^.*)(\\.\\w+)(\\/.*|$)", "\\2", dat$Domain)
    
    return(dat)
}