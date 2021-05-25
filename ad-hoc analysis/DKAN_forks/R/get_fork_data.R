### GET DKAN FORK DATA

get_password <- function() {
    config <- read.csv("config.config")
    
    return(config)
}

get_fork_data <- function(repo, per_page = 100) {
    library(jsonlite)
    library(dplyr)
    library(httr)
    
    prepo <- gsub("/", "_", repo)
    path <- paste0("./data/raw/fork_data_", prepo, "_", 
                   format(Sys.Date(), "%m%d%Y"), ".csv")
    
    # CHECK IF RAW DATA EXISTS FIRST BEFORE REPULLING 
    if(file.exists(path)) {
        dfdat <- read.csv(path)
    } else {
        URL <- paste0("https://api.github.com/repos/", repo, 
                      "/forks?per_page=", per_page)
        
        get_pw <- get_password()
        tmp <- GET(URL, add_headers(Authorization = paste0("token ", get_pw$token[1])))
        
        dfdat <- as.data.frame(fromJSON(content(tmp, as = "text")))
        
        page <- 2
        while(dim(dfdat)[1] %% per_page == 0){
            URL <- paste0(URL, "&page=", page)
            page <- page + 1
            tmp <- GET(URL, add_headers(Authorization = paste0("token ", get_pw$token[1])))
            tmp2 <- as.data.frame(fromJSON(content(tmp, as = "text")))
            dfdat <- bind_rows(dfdat, tmp2)
        }
        
        if(dim(dfdat[dfdat$forks > 0, ])[1] > 0) {
            tmp <- get_forks_of_forks(dfdat$forks_url[dfdat$forks > 0])
            dfdat <- bind_rows(dfdat, tmp)
        }
        
        dfdat <- flatten(dfdat)
        write.csv(dfdat, file = path, row.names = FALSE)
    }
    
    return(dfdat)
}

get_forks_of_forks <- function(fork_urls) {
    library(httr)
    
    findat <- data.frame()
    
    get_pw <- get_password()
    
    for(url in fork_urls) {
        tmp <- GET(url, add_headers(Authorization = paste0("token ", get_pw$token[1])))
        tmp2 <- as.data.frame(fromJSON(content(tmp, as = "text")))
        
        findat <- bind_rows(findat, tmp2)
    }
    
    return(findat)
}

get_repo_data <- function(repo) {
    library(jsonlite)
    library(httr)
    library(lubridate)
    
    prepo <- gsub("/", "_", repo)
    path <- paste0("./data/raw/repo_data_", prepo, "_", 
                   format(Sys.Date(), "%m%d%Y"), ".json")
    
    # CHECK IF RAW DATA EXISTS FIRST BEFORE REPULLING 
    if(file.exists(path)) {
        dfdat <- fromJSON(path)
    } else {
        URL <- paste0("https://api.github.com/repos/", repo)
        
        get_pw <- get_password()
        tmp <- GET(URL, add_headers(Authorization = paste0("token ", get_pw$token[1])))
        
        for_save <- content(tmp, as = "text")
        write(for_save, file = path)
        
        dfdat <- fromJSON(content(tmp, as = "text"))
    }
    
    new_dat <- data.frame(full_name = paste0(dfdat$owner$login, "/", dfdat$name),
                          created_at = as_datetime(dfdat$created_at, format = "%Y-%m-%dT%H:%M:%S"),
                          pushed_at = as_datetime(dfdat$pushed_at, format = "%Y-%m-%dT%H:%M:%S"))
    return(new_dat)
}

clean_fork_data <- function(dat, repo) {
    library(lubridate)
    
    # UPDATE THE DATES
    dat$created_at <- as_datetime(dat$created_at, format = "%Y-%m-%dT%H:%M:%S")
    dat$updated_at <- as_datetime(dat$updated_at, format = "%Y-%m-%dT%H:%M:%S")
    dat$pushed_at <- as_datetime(dat$pushed_at, format = "%Y-%m-%dT%H:%M:%S")
    
    dat <- dat[order(dat$created_at), ]
    dat$fork_num <- 1:length(dat$id)
    dat$activity <- as.numeric(dat$pushed_at - dat$created_at) / 86400
    
    repo <- gsub("/", "_", repo)
    path <- paste0("data/interim/fork_data_", repo, "_", 
                   format(Sys.Date(), "%m%d%Y"), ".csv")
    write.csv(dat, path, row.names = FALSE)
    
    return(dat)
}