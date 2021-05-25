# Do the Analysis

plot_forks_over_time <- function(cleaned_dat) {
    library(ggplot2)
    
    ggplot(cleaned_dat, aes(x = created_at, y = fork_num, color = default_branch)) + 
        geom_point(stat = "identity") +
        geom_line(stat = "identity") + 
        theme(panel.background = element_blank(),
              panel.grid.major.y = element_line(color = "light gray"),
              legend.position = "top",
              legend.box.background = element_blank(),
              legend.background = element_blank(), 
              legend.key = element_blank()) + 
        labs(color = "Default Branch") + 
        xlab("Fork Creation Date") +
        ylab("Cumulative Number of Forks")
}

plot_ckan_forks_over_time <- function(cleaned_dat) {
    library(ggplot2)
    
    ggplot(cleaned_dat, aes(x = created_at, y = fork_num)) + 
        geom_line(stat = "identity") + 
        theme(panel.background = element_blank(),
              panel.grid.major.y = element_line(color = "light gray"),
              legend.position = "none",
              legend.box.background = element_blank(),
              legend.background = element_blank(), 
              legend.key = element_blank()) + 
        labs(color = "Default Branch") + 
        xlab("Fork Creation Date") +
        ylab("Cumulative Number of Forks")
}

plot_ckan_dkan_forks_over_time <- function(dkan, ckan) {
    library(ggplot2)
    
    dkan <- dkan[, c("name", "created_at", "fork_num")]
    dkan$name <- "dkan"
    ckan <- ckan[, c("name", "created_at", "fork_num")]
    ckan$name <- "ckan"
    
    cleaned_dat <- rbind(dkan, ckan)
    
    ggplot(cleaned_dat, aes(x = created_at, y = fork_num, group = name, 
                            color = name)) + 
        geom_line(stat = "identity", size = 1.25) + 
        scale_color_manual(values = c("#D83933", "#00A398")) + 
        theme(panel.background = element_blank(),
              panel.grid.major.y = element_line(color = "light gray"),
              legend.position = "top",
              legend.box.background = element_blank(),
              legend.background = element_blank(), 
              legend.key = element_blank(), 
              legend.title = element_blank(),
              text = element_text(size = 20)) + 
        xlab("Fork Creation Date") +
        ylab("Cumulative Number of Forks")
}


plot_active_forks <- function(cleaned_dat) {
    library(ggplot2)
    
    ggplot(cleaned_dat, 
           aes(y = full_name, x = created_at, group = full_name, xmin = created_at, xmax = pushed_at)) + 
        geom_pointrange(stat = "identity") + 
        geom_vline(xintercept = max(cleaned_dat$pushed_at, na.rm = TRUE) - (30*86400), 
                   color = "red") +
        annotate(geom = "text", x = max(cleaned_dat$pushed_at, na.rm = TRUE) - (300*86400), 
                 y = 2.5, label = format(max(cleaned_dat$pushed_at, na.rm = TRUE) - (30*86400), 
                                       "%Y-%m-%d"),
                 color = "red") + 
        theme(panel.background = element_blank(),
              panel.grid.major.y = element_line(color = "light gray"),
              legend.position = "top",
              legend.box.background = element_blank(),
              legend.background = element_blank(), 
              legend.key = element_blank()) + 
        labs(color = "Default Branch") + 
        xlab("Date") +
        ylab("Repo") +
        ggtitle("Repo Activity Timeline", 
                subtitle = "Fork Creation Date -> Most Recent Push Date")
}
