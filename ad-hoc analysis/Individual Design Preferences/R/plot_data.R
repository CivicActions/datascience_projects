# Plot Data

plot_high_level <- function(dat) {
    library(ggplot2)
    
    plot_dat <- high_level_summary(dat)
    
    ggplot(plot_dat, aes(x = reorder(variable, -value), y = value)) + 
        geom_bar(stat = "identity", fill = "#D83933") +
        geom_text(label = round(plot_dat$value, 2), 
                  nudge_y = -1 * (plot_dat$value / 2)) + 
        theme(panel.background = element_blank(),
              panel.grid.major.y = element_line(color = "light gray"),
              panel.grid.major.x = element_blank(),
              axis.ticks = element_blank(), 
              text = element_text(size = 16, color = "black")) +
        xlab("High Level Area") +
        ylab("Average Score")
}

plot_design_data <- function(dat) {
    library(ggplot2)
    
    plot_dat <- design_data(dat)
    
    ggplot(plot_dat, aes(x = reorder(variable, -mean))) + 
        geom_pointrange(aes(y = mean, ymin = min, ymax = max)) + 
        geom_text(label = round(plot_dat$mean, 2), nudge_x = -0.2, y = plot_dat$mean) + 
        geom_text(label = round(plot_dat$min, 2), nudge_x = -0.2, y = plot_dat$min) + 
        geom_text(label = round(plot_dat$max, 2), nudge_x = -0.2, y = plot_dat$max) + 
        scale_y_continuous(limits = c(1, 5)) +
        theme(panel.background = element_blank(),
              panel.grid.major.y = element_line(color = "light gray"),
              panel.grid.major.x = element_blank(),
              axis.ticks = element_blank(), 
              text = element_text(size = 16, color = "black")) +
        xlab("Design Area") +
        ylab("Score")
}

plot_visual_data <- function(dat) {
    library(ggplot2)
    
    plot_dat <- visual_data(dat)
    
    ggplot(plot_dat, aes(x = reorder(variable, -mean))) + 
        geom_pointrange(aes(y = mean, ymin = min, ymax = max)) + 
        geom_text(label = round(plot_dat$mean, 2), nudge_x = -0.2, y = plot_dat$mean) + 
        geom_text(label = round(plot_dat$min, 2), nudge_x = -0.2, y = plot_dat$min) + 
        geom_text(label = round(plot_dat$max, 2), nudge_x = -0.2, y = plot_dat$max) + 
        scale_y_continuous(limits = c(1, 5)) +
        theme(panel.background = element_blank(),
              panel.grid.major.y = element_line(color = "light gray"),
              panel.grid.major.x = element_blank(),
              axis.ticks = element_blank(), 
              text = element_text(size = 16, color = "black")) +
        xlab("Visual Design Area") +
        ylab("Score")
}

plot_interaction_data <- function(dat) {
    library(ggplot2)
    
    plot_dat <- interaction_data(dat)
    
    ggplot(plot_dat, aes(x = reorder(variable, -mean))) + 
        geom_pointrange(aes(y = mean, ymin = min, ymax = max)) + 
        geom_text(label = round(plot_dat$mean, 2), nudge_x = -0.2, y = plot_dat$mean) + 
        geom_text(label = round(plot_dat$min, 2), nudge_x = -0.2, y = plot_dat$min) + 
        geom_text(label = round(plot_dat$max, 2), nudge_x = -0.2, y = plot_dat$max) + 
        scale_y_continuous(limits = c(1, 5)) +
        theme(panel.background = element_blank(),
              panel.grid.major.y = element_line(color = "light gray"),
              panel.grid.major.x = element_blank(),
              axis.ticks = element_blank(), 
              text = element_text(size = 16, color = "black")) +
        xlab("Interaction Design Area") +
        ylab("Score")
}

plot_content_data <- function(dat) {
    library(ggplot2)
    
    plot_dat <- content_data(dat)
    
    ggplot(plot_dat, aes(x = reorder(variable, -mean))) + 
        geom_pointrange(aes(y = mean, ymin = min, ymax = max)) + 
        geom_text(label = round(plot_dat$mean, 2), nudge_x = -0.2, y = plot_dat$mean) + 
        geom_text(label = round(plot_dat$min, 2), nudge_x = -0.2, y = plot_dat$min) + 
        geom_text(label = round(plot_dat$max, 2), nudge_x = -0.2, y = plot_dat$max) + 
        scale_y_continuous(limits = c(1, 5)) +
        theme(panel.background = element_blank(),
              panel.grid.major.y = element_line(color = "light gray"),
              panel.grid.major.x = element_blank(),
              axis.ticks = element_blank(), 
              text = element_text(size = 16, color = "black")) +
        xlab("Content Design Area") +
        ylab("Score")
}

plot_people_data <- function(dat) {
    library(ggplot2)
    
    plot_dat <- people_data(dat)
    
    ggplot(plot_dat, aes(x = reorder(variable, -mean))) + 
        geom_pointrange(aes(y = mean, ymin = min, ymax = max)) + 
        geom_text(label = round(plot_dat$mean, 2), nudge_x = -0.2, y = plot_dat$mean) + 
        geom_text(label = round(plot_dat$min, 2), nudge_x = -0.2, y = plot_dat$min) + 
        geom_text(label = round(plot_dat$max, 2), nudge_x = -0.2, y = plot_dat$max) + 
        scale_y_continuous(limits = c(1, 5)) +
        theme(panel.background = element_blank(),
              panel.grid.major.y = element_line(color = "light gray"),
              panel.grid.major.x = element_blank(),
              axis.ticks = element_blank(), 
              text = element_text(size = 16, color = "black")) +
        xlab("People Management Area") +
        ylab("Score")
}

plot_individual_preferences <- function(dat) {
    library(ggplot2)
    library(RColorBrewer)
    
    plot_dat <- individual_data(dat)
    
    ggplot(plot_dat, aes(x = variable, y = rank, group = variable, fill = variable)) + 
        geom_bar(stat = "identity", position = "dodge") + 
        facet_wrap(~ email) + 
        scale_fill_brewer(palette = "Blues") +
        theme(panel.background = element_blank(),
              panel.grid.major.y = element_line(color = "light gray"),
              panel.grid.major.x = element_blank(),
              axis.ticks = element_blank(), 
              text = element_text(size = 16, color = "black"),
              legend.position = "top", 
              legend.title = element_blank(), 
              strip.background = element_blank(),
              axis.text.x = element_text(angle = 45, hjust = 1)) +
        xlab("High Level Area") +
        ylab("Group Preference")
}