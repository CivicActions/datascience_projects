# GET BEN BALTER DATA
get_ben_b_dat <- function() {
    URL <- "https://ben.balter.com/2021-analysis-of-federal-dotgov-domains/data.csv"

    dat <- read.csv(URL)

    write.csv(dat, "ben_balter_data.csv", row.names = FALSE)

    return(dat)
}

get_i18n <- function(domains) {
    library(rvest)
    library(reshape2)

    checker <- "https://validator.w3.org/i18n-checker/check?uri="
    i18n_dat <- data.frame(uri = domains,
                           api = paste0(checker, domains))

    fin_dat <- data.frame()
    for(row in 1:length(i18n_dat$api)){
        tmp <- as.data.frame(read_html(i18n_dat$api[row]) %>%
                                 html_nodes("table") %>%
                                 html_table())

        if(dim(tmp)[1] == 0) {
            next
        }

        names(tmp) <- c("class", "response", "code")
        tmp <- tmp[tmp$response != "", ]
        tmp$uri = i18n_dat$uri[row]

        fin_dat <- rbind(fin_dat, tmp)
    }

    fin_dat <- dcast(fin_dat, uri ~ class, value.var = c("response", "code"))

    return(fin_dat)
}
