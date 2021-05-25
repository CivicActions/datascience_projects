# READ IN DATA

read_in_data <- function(file) {
    dat <- read.csv(file)
    
    return(dat)
}

high_level_summary <- function(dat) {
    library(reshape2)
    
    sumdat <- data.frame(design = sum(dat[, c(3:10)]) / (8 * 9),
                         visual = sum(dat[, c(13:18)]) / (6 * 9),
                         interaction = sum(dat[, c(21:24)]) / (4 * 9),
                         content = sum(dat[, c(27:32)]) / (6 * 9),
                         people = sum(dat[, c(35:37)]) / (3 * 9))
    
    sumdat <- melt(sumdat)
    
    sumdat$variable <- c("Design Strategy\n& Research", "Visual Design", 
                         "Interaction Design", "Content Design", "People Management")
    
    return(sumdat)
}

design_data <- function(dat) {
    tmp <- dat[, c(3:10)]
    
    sumdat <- data.frame()
    
    for(name in names(tmp)) {
        rw <- data.frame(variable = name, 
                         min = min(tmp[, name], na.rm = TRUE),
                         mean = mean(tmp[, name], na.rm = TRUE),
                         max = max(tmp[, name], na.rm = TRUE))
            
            sumdat <- rbind(sumdat, rw)
    }
    
    sumdat$variable <- c("Design Strategy", "Interviewing", "Usability Testing",
                         "Presentation", "Synthesis", "Ethnography", 
                         "Service Design", "Quantitative Research")
    
    return(sumdat)
}

visual_data <- function(dat) {
    tmp <- dat[, c(13:18)]
    
    sumdat <- data.frame()
    
    for(name in names(tmp)) {
        rw <- data.frame(variable = name, 
                         min = min(tmp[, name], na.rm = TRUE),
                         mean = mean(tmp[, name], na.rm = TRUE),
                         max = max(tmp[, name], na.rm = TRUE))
        
        sumdat <- rbind(sumdat, rw)
    }
    
    sumdat$variable <- c("UI Design", "Illustration", "Design System",
                         "Designing for\nAccessibility", "Product Design", 
                         "Motion Design")
    
    return(sumdat)
}

interaction_data <- function(dat) {
    tmp <- dat[, c(21:24)]
    
    sumdat <- data.frame()
    
    for(name in names(tmp)) {
        rw <- data.frame(variable = name, 
                         min = min(tmp[, name], na.rm = TRUE),
                         mean = mean(tmp[, name], na.rm = TRUE),
                         max = max(tmp[, name], na.rm = TRUE))
        
        sumdat <- rbind(sumdat, rw)
    }
    
    sumdat$variable <- c("Wireframing", "Prototyping", "Iteration",
                         "Designing for\nAccessibility")
    
    return(sumdat)
}

content_data <- function(dat) {
    tmp <- dat[, c(27:32)]
    
    sumdat <- data.frame()
    
    for(name in names(tmp)) {
        rw <- data.frame(variable = name, 
                         min = min(tmp[, name], na.rm = TRUE),
                         mean = mean(tmp[, name], na.rm = TRUE),
                         max = max(tmp[, name], na.rm = TRUE))
        
        sumdat <- rbind(sumdat, rw)
    }
    
    sumdat$variable <- c("Information Architecture", "UX Writing", 
                         "Plain Language", "Content Modeling", 
                         "Content Strategy", "Designing for\nAccessibilty")
    
    return(sumdat)
}

people_data <- function(dat) {
    tmp <- dat[, c(35:37)]
    
    sumdat <- data.frame()
    
    for(name in names(tmp)) {
        rw <- data.frame(variable = name, 
                         min = min(tmp[, name], na.rm = TRUE),
                         mean = mean(tmp[, name], na.rm = TRUE),
                         max = max(tmp[, name], na.rm = TRUE))
        
        sumdat <- rbind(sumdat, rw)
    }
    
    sumdat$variable <- c("Coaching & Mentoring", "Providing Feedback", 
                         "People Managmenet")
    
    return(sumdat)
}

individual_data <- function(dat) {
    library(reshape2)
    library(dplyr)
    
    rowdat <- data.frame(design = rowSums(dat[, c(3:10)]) / (8),
                         visual = rowSums(dat[, c(13:18)]) / (6),
                         interaction = rowSums(dat[, c(21:24)]) / (4),
                         content = rowSums(dat[, c(27:32)]) / (6),
                         people = rowSums(dat[, c(35:37)]) / (3))
    
    sumdat <- cbind(dat[, 2], rowdat)
    names(sumdat) <- c("email", names(sumdat)[2:6])
    
    sumdat <- melt(sumdat, id.vars = "email", measure.vars = c("design", "visual", "interaction", "content", "people"))
    sumdat <- sumdat[order(sumdat$email, -sumdat$value), ]
    sumdat$variable <- case_when(
        sumdat$variable == "design" ~ "Design Strategy & Research",
        sumdat$variable == "visual" ~ "Visual Design",
        sumdat$variable == "interaction" ~ "Interaction Design",
        sumdat$variable == "content" ~ "Content Design",
        sumdat$variable == "people" ~ "People Management"
    )
    sumdat$rank <- 5:1
    
    return(sumdat)
}

top_people_per_group <- function(dat) {
    library(dplyr)
    sumdat <- individual_data(dat)
    
    sumdat <- sumdat %>% 
        group_by(variable) %>% 
        summarise(people = paste(unique(email[rank == 5]), collapse = " | ", sep = ","))
    
    sumdat$people <- gsub("@civicactions.com", "", sumdat$people)
    sumdat$people <- gsub("\\.", " ", sumdat$people)
    
    names(sumdat) <- c("Design Practice Area", "People")
    
    return(sumdat)
}