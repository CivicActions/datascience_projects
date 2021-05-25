library(flexdashboard)
library(shiny)
library(shinydashboard)
library(scales)
library(plotly)
library(ggplot2)
library(reshape2)
library(RColorBrewer)
library(dplyr)

header <- dashboardHeader(
    title = "California - Statewide Telework Dashboard", 
    titleWidth = 750,
    
    tags$li(a(href = paste0('https://twitter.com/intent/tweet?text=Check%20out',
                            '%20how%20much%20carbon%20California%20',
                            'is%20removing%20from%20the%20atmosphere%20by%20al',
                            'lowing%20its%20employees%20to%20telework!%20https',
                            '://jakelearnsdatascience.shinyapps.io/california_',
                            'telework_dashboard/'),
              target = "_blank",
              icon("twitter"),
              title = "Share this app on Twitter"),
            class = "dropdown"),
    
    tags$li(a(href = 'https://github.com/CivicActions/datascience/tree/main/cali_shiny',
              target = "_blank",
              icon("github"),
              title = "Check out the code on Github"),
            class = "dropdown"),
    
    tags$li(a(href = 'https://www.civicactions.com',
              target = "_blank",
              icon("bar-chart"),
              title = "Back to CivicActions"),
            class = "dropdown")
)

sidebar <- dashboardSidebar(
    selectInput(inputId = "agencies", label = "Department Name", 
                multiple = TRUE, choices = NULL)#,
    
    # submitButton(text = "Submit")
)

body <- dashboardBody(
    includeCSS("custom.css"), 
    fluidRow(
        tabBox(
            id = "tabset",
            width = 12,
            height = 575,
            
            tabPanel(
                title = "Telework Eligibility",
                column(
                    width = 3,
                    
                    box(
                        width = NULL, height = "500",
                        
                        # AGENCIES REPORTING
                        valueBoxOutput("total_agencies", width = NULL),
                        # TOTAL WORKERS
                        valueBoxOutput("total_workers", width = NULL),
                        # TELEWORK ELIGIBLE
                        valueBoxOutput("telework_eligible", width = NULL),
                        # NON-ELIGIBLE
                        valueBoxOutput("not_telework_eligible", width = NULL)
                    )
                ),
                
                column(
                    width = 3,
                    
                    box(
                        width = NULL, height = "500",
                        
                        flexdashboard::gaugeOutput("elgible_for_telework_freq", 
                                                   height = "225px"),
                        flexdashboard::gaugeOutput("elgible_for_telework_prop", 
                                                   height = "225px")
                    )
                ),
                # THIS BOX SHOULD VISUALIZE THE DATA FROM THE LAST BOX
                tabBox(
                    width = 6, height = "500",
                    
                    tabPanel(
                        title = "Barchart: Number Eligible for Telework", 
                        plotOutput("elig_vs_nonelig", height = "450")
                    ),
                    
                    tabPanel(
                        title = "Barchart: Proportion Eligible for Telework", 
                        plotOutput("elig_vs_nonelig_prop", height = "450")
                    )
                )
            ),
            
            tabPanel(
                title = "Telework Utilization",
                column(
                    width = 3,

                    box(
                        width = NULL, height = "500",

                        # TELEWORK ELIGIBLE
                        valueBoxOutput("telework_eligible1", width = NULL),
                        # TELEWORKING FULL TIME
                        valueBoxOutput("teleworking_fulltime", width = NULL),
                        # TELEWORKING PART TIME
                        valueBoxOutput("teleworking_parttime", width = NULL),
                        # NOT TELEWORKING
                        valueBoxOutput("teleworking_notime", width = NULL)
                    )
                ),
                
                column(
                    width = 3,
                    
                    box(
                        width = NULL, height = "500",
                        
                        flexdashboard::gaugeOutput("people_teleworking_prop", 
                                                   height = "225px"),
                        flexdashboard::gaugeOutput("telework_rate", 
                                                   height = "225px")
                    )
                ),
                
                tabBox(
                    width = 6, height = "500",
                    
                    tabPanel(
                        title = "Number Teleworking", 
                        plotOutput("telework_breakdown", height = "450")
                    ),
                    
                    tabPanel(
                        title = "Proportion Teleworking", 
                        plotOutput("telework_breakdown_prop", height = "450")
                    )
                )
            ),
            
            tabPanel(
                title = "Distribution of Commutes",
                
                column(
                    width = 3,
                    
                    box(
                        width = NULL, height = "500",
                        
                        valueBoxOutput("average_miles", width = NULL),
                        valueBoxOutput("average_minutes", width = NULL),
                        valueBoxOutput("longest_drive_miles", width = NULL),
                        valueBoxOutput("longest_drive_minutes", width = NULL)
                    )
                ),
                tabBox(
                    width = 9, height = "500",
                    
                    tabPanel(
                        title = "Distance (miles)", 
                        plotOutput("telework_commute_distance_hist", height = "450")
                    ),
                    
                    tabPanel(
                        title = "Time (minutes)",
                        plotOutput("telework_commute_minutes_hist", height = "450")
                    )
                )
            ),
            
            tabPanel(
                title = "About Telework Dashboard",
                
                h4(strong("Description")),
                p("This dashboard combines departments' telework data"),
                
                h4(strong("Audience")),
                p(paste0("This dashboard and its data are intended to be avail",
                         "able to the public")),
                
                h4(strong("Data Sources")),
                p(paste0("Each deparment provides their own data, based on thei",
                        "r internal telework tracking systems. Guidance on how",
                        " to collect this data is available on the "), 
                  a("Reporting Requirements Page.", 
                    href = paste0("https://telework.govops.ca.gov/track-telewo",
                                  "rk/reporting-requirements/"),
                    target = "_blank"), 
                  paste0("Cumulative savings estimates go back to when they be",
                         "gan participating.")),
                
                h4(strong("Assumptions")),
                p(paste0("This dashboard represents a generalized esimation us",
                         "ing available data with the folloing assumpions:"),
                  br(), br(), strong("Commute Calculation:"), 
                  paste0(" All employees are assumed to",
                         " drive alone. No precise data is available for emplo",
                         "yee's use of public transportation or carpools, so t",
                         "hese commute methods are not currently factored in. ",
                         "We consider it reasonable to assume that actual savi",
                         "ngs (both in dollars and CO2) are probably slightly ",
                         "less than shown, due to this uncertainty. Holidays a",
                         "nd vacation days are excluded from calculations. Act",
                         "ual telework days may differ from the reported counts",
                         " due to various individual circumstances. In limited",
                         " cases where the commute distance could not be calcu",
                         "lated, the average commute distance for all other em",
                         "ployees is used. Data for employees wiht PO Box (0 m",
                         "iles) or commuting over 100 miles one-way were exclu",
                         "ded from the average calculation."), 
                  br(), br(), strong("Energy Savings Calculation:"),
                  paste0(" Historic average gas prices in California come from",
                         " the California Energy Commision's "),
                  a("weekly retail gasoline prices report.", 
                    href = paste0("https://ww2.energy.ca.gov/almanac/transport",
                                  "ation_data/gasoline/retail_gasoline_prices2",
                                  "_cms.html"), 
                    target = "_blank"),
                  paste0(" Mid-grade gasoline prices are used for calculation",
                         "s. The average fuel economy for gasoline passenger v",
                         "ehicles is 24.4 mpg, per the California Energy Commi",
                         "sion's analysis of the Department of Motor Vehicles'",
                         " registration data for personal gasoline vehicles, a",
                         "s of the end of 2019. IRS mileage rate is taken from",
                         " the "),
                  a("IRS standard mileage reimbursement rates.", 
                    href = paste0("https://www.irs.gov/tax-professionals/stand",
                                  "ard-mileage-rates"),
                    target = "_blank"), br(), br(), 
                  strong("CO2 Avoided Calculation: "),
                  paste0("The common conversion factor of 8,887 grams of CO2 e",
                         "mmisions per gallon of gasoline was used. Conversion",
                         " factor for carbon sequestered is 0.77 metric ton CO",
                         "2/acre/year annually by one acre of average U.S. for",
                         "est (from the Environmental Protection Agency's "),
                  a("Greenhouse Gases Equivalencies Calculator References",
                    href = paste0("https://www.epa.gov/energy/greenhouse-gases",
                                  "-equivalencies-calculator-calculations-and-",
                                  "references"),
                    target = "_blank"), ").")
                
            ),
            
            tabPanel(
                title = "Dashboard Data Dictionary",
                
                p("To be added.")
            )
        )
    ),
    
    fluidRow(
        tabBox(
            width = 12, 
            height = 300,
            tabPanel(
                title = "Average Savings per Teleworker",
                
                column(
                    width = 6,
                    valueBoxOutput("daily_driving_distance", width = NULL),
                    valueBoxOutput("daily_driving_minutes", width = NULL)
                ),
                
                column(
                    width = 6,
                    
                    valueBoxOutput("daily_driving_expense", width = NULL),
                    valueBoxOutput("daily_driving_gas", width = NULL)
                )
            ),
            
            tabPanel(
                title = "Organizational Weekly Savings",
                
                column(
                    width = 4,
                    
                    valueBoxOutput("weekly_miles", width = NULL),
                    valueBoxOutput("weekly_minutes", width = NULL)
                ),
                
                column(
                    width = 4, 
                    
                    valueBoxOutput("weekly_gallons", width = NULL),
                    valueBoxOutput("weekly_carbon", width = NULL)
                ),
                
                column(
                    width = 4, 
                    
                    # https://calculator.carbonfootprint.com/calculator.aspx?tab=3
                    valueBoxOutput("weekly_flights", width = NULL),
                    valueBoxOutput("weekly_trees", width = NULL)
                )
            ),
            
            tabPanel(
                title = "Cumulative Organizational Savings",
                
                column(
                    width = 4,
                    
                    valueBoxOutput("total_miles", width = NULL),
                    valueBoxOutput("total_minutes", width = NULL)
                ),
                
                column(
                    width = 4,
                    
                    valueBoxOutput("total_gallons", width = NULL),
                    valueBoxOutput("total_carbon", width = NULL)
                ),
                
                column(
                    width = 4,
                    
                    # https://calculator.carbonfootprint.com/calculator.aspx?tab=3
                    valueBoxOutput("total_flights", width = NULL),
                    valueBoxOutput("total_trees", width = NULL)
                )
            )
        )
    )
)

ui <- dashboardPage(header, sidebar, body)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

    ####################
    ## DATA RETRIEVAL ##
    ##   FUNCTIONS    ##
    ####################
    
    get_data <- reactive({
        URL <- paste0("https://data.ca.gov/dataset/4ce08c09-1b91-4ab8-997b-20bbe88cc4",
                      "11/resource/eea6715b-0a13-4bfc-8e42-1cd4f8481ac8/download/dgs-",
                      "telework-aggregate-by-week.csv")
        
        dat <- read.csv(URL)
        
        jake <- dat
        jake$Department <- "JAKE"
        jake$All.Staff <- (jake$All.Staff + (jake$All.Staff * rnorm(dim(jake)[1], mean = 0.25, sd = 0.05)))
        jake$Telework.eligible.staff <- (jake$Telework.eligible.staff + 
                                             (jake$Telework.eligible.staff * rnorm(dim(jake)[1], mean = 0.25, sd = 0.05)))
        jake$Full.time.teleworkers <- (jake$Full.time.teleworkers + 
                                             (jake$Full.time.teleworkers * rnorm(dim(jake)[1], mean = 0.25, sd = 0.05)))
        jake$Part.time.teleworkers <- (jake$Part.time.teleworkers + 
                                           (jake$Part.time.teleworkers * rnorm(dim(jake)[1], mean = 0.25, sd = 0.05)))
        jake$Working.days <- (jake$Working.days + 
                                  (jake$Working.days * rnorm(dim(jake)[1], mean = 0.25, sd = 0.05)))
        jake$Telework.days <- (jake$Telework.days + 
                                  (jake$Telework.days * rnorm(dim(jake)[1], mean = 0.25, sd = 0.05)))
        jake$Teleworker.average.one.way.commute.miles <- (jake$Teleworker.average.one.way.commute.miles + 
                                                              (jake$Teleworker.average.one.way.commute.miles * rnorm(dim(jake)[1], mean = 0.25, sd = 0.05)))
        jake$Teleworker.average.one.way.commute.minutes <- (jake$Teleworker.average.one.way.commute.minutes + 
                                                              (jake$Teleworker.average.one.way.commute.minutes * rnorm(dim(jake)[1], mean = 0.25, sd = 0.05)))
        
        dat <- rbind(dat, jake)
        dat$Week <- as.Date(dat$Week, format = "%m/%d/%Y")
        dat$not_elig <- dat$All.Staff - dat$Telework.eligible.staff
        dat$not_tele <- dat$Telework.eligible.staff - (dat$Full.time.teleworkers - dat$Part.time.teleworkers)
        
        return(dat)
    })
    
    observe({
        updateSelectInput(session = session, inputId = "agencies", 
                          choices = rbind("ALL", unique(get_data()$Department)), 
                          selected = "ALL")
    })
    
    get_other_dat <- reactive({
        URL <- paste0("https://data.ca.gov/dataset/4ce08c09-1b91-4ab8-997b-20b",
                      "be88cc411/resource/ca341c2a-5ffa-44ac-972b-9dcff31a1a33",
                      "/download/dgs-employees-telework-status-20201228.csv")
        
        dat <- read.csv(URL)
        
        dat$tele_class <- case_when(
            dat$Telework.Eligible.Class == "No" ~ "Not Telework Eligible",
            dat$Telework.Days == 0 ~ "No Telework",
            dat$Telework.Days == 5 ~ "Full Telework",
            1 == 1 ~ "Partial Telework"
        )
            
        return(dat)
    })
    
    ##############################
    ## TELEWORK ELIGIBILITY TAB ##
    ##       VALUE BOXES        ##
    ##############################
    
    output$total_workers <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            comma(sum(dat$All.Staff[dat$Week == max(dat$Week)], 
                      na.rm = TRUE)),
            paste0("Total Staff; Week of ", max(dat$Week)),
            icon = icon("user-friends", lib = "font-awesome"), 
            color = "light-blue"
        )
    })
    
    output$total_agencies <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        unique_agencies <- as.numeric(length(unique(dat$Department[dat$Week == max(dat$Week)])))
        
        valueBox(
            unique_agencies,
            paste0("Agencies Reporting; Week of ", max(dat$Week)),
            icon = icon("building", lib = "font-awesome"), 
            color = "light-blue"
        )
    })
    
    output$telework_eligible <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            comma(sum(dat$Telework.eligible.staff[dat$Week == max(dat$Week)], 
                      na.rm = TRUE)),
            paste0("Total Eligible Teleworkers; Week of ", max(dat$Week)),
            icon = icon("headset", lib = "font-awesome"), 
            color = "light-blue"
        )
    })
    
    output$not_telework_eligible <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            comma(sum(dat$not_elig[dat$Week == max(dat$Week)], 
                      na.rm = TRUE)),
            paste0("Total Ineligible for Telework; Week of ", max(dat$Week)),
            icon = icon("car", lib = "font-awesome"), 
            color = "light-blue"
        )
    })
    
    ##############################
    ## TELEWORK UTILIZATION TAB ##
    ##       VALUE BOXES        ##
    ##############################
    
    output$telework_eligible1 <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            comma(sum(dat$Telework.eligible.staff[dat$Week == max(dat$Week)], 
                      na.rm = TRUE)),
            paste0("Total Eligible Teleworkers; Week of ", max(dat$Week)),
            icon = icon("headset", lib = "font-awesome"), 
            color = "light-blue"
        )
    })
    
    output$teleworking_fulltime <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            comma(sum(dat$Full.time.teleworkers[dat$Week == max(dat$Week)], 
                      na.rm = TRUE)),
            paste0("Full-time Teleworkers; Week of ", max(dat$Week)),
            icon = icon("thermometer-full", lib = "font-awesome"), 
            color = "light-blue"
        )
    })
    
    output$teleworking_parttime <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            comma(sum(dat$Part.time.teleworkers[dat$Week == max(dat$Week)], 
                      na.rm = TRUE)),
            paste0("Part-time Teleworkers; Week of ", max(dat$Week)),
            icon = icon("thermometer-half", lib = "font-awesome"), 
            color = "light-blue"
        )
    })
    
    output$teleworking_notime <- renderValueBox({
        dat <- get_data()

        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }

        valueBox(
            comma(sum(dat$not_tele[dat$Week == max(dat$Week)],
                      na.rm = TRUE)),
            paste0("Not Teleworking; Week of ", max(dat$Week)),
            icon = icon("thermometer-empty", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    #########################
    ## DIST OF COMMUTE TAB ##
    ##    VALUE BOXES      ##
    #########################
    
    output$average_miles <- renderValueBox({
        dat <- get_other_dat()
        
        valueBox(
            round(mean(dat$X1.Way.Commute.Miles, na.rm = TRUE), 2),
            paste0("Average Commute Distance (miles)"),
            icon = icon("thermometer-empty", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$average_minutes <- renderValueBox({
        dat <- get_other_dat()
        
        valueBox(
            round(mean(dat$X1.Way.Commute.Minutes, na.rm = TRUE), 2),
            paste0("Average Commute Time (minutes)"),
            icon = icon("thermometer-empty", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$longest_drive_miles <- renderValueBox({
        dat <- get_other_dat()
        
        valueBox(
            round(max(dat$X1.Way.Commute.Miles, na.rm = TRUE), 2),
            paste0("Longest Commute (miles)"),
            icon = icon("thermometer-empty", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$longest_drive_minutes <- renderValueBox({
        dat <- get_other_dat()
        
        valueBox(
            round(max(dat$X1.Way.Commute.Minutes, na.rm = TRUE), 2),
            paste0("Longest Commute (minutes)"),
            icon = icon("thermometer-empty", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    #########################
    ## INDIVIDUAL SAVINGS  ##
    ##    VALUE BOXES      ##
    #########################
    
    output$daily_driving_distance <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            paste(comma(sum(dat$Teleworker.average.one.way.commute.miles[dat$Week == max(dat$Week)] * 2,
                      na.rm = TRUE), accuracy = 0.1), "miles"),
            paste0("Daily Driving Distance; Week of ", max(dat$Week)),
            icon = icon("road", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$daily_driving_minutes <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            paste(comma(sum(dat$Teleworker.average.one.way.commute.minutes[dat$Week == max(dat$Week)] * 2,
                            na.rm = TRUE), accuracy = 0.1), "mins"),
            paste0("Daily Driving Time; Week of ", max(dat$Week)),
            icon = icon("clock", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$daily_driving_expense <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            "$88 per week",
            paste0("Total Driving Expense; Week of ", max(dat$Week)),
            icon = icon("dollar-sign", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$daily_driving_gas <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            "$25 per week",
            paste0("Gas Expense; Week of ", max(dat$Week)),
            icon = icon("gas-pump", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    ########################
    ## WEEKLY ORG SAVINGS ##
    ##    VALUE BOXES     ##
    ########################
    
    output$weekly_miles <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            paste(comma(sum(dat$Teleworker.average.one.way.commute.miles[dat$Week == max(dat$Week)] * 
                          dat$Telework.days[dat$Week == max(dat$Week)] * 2, 
                          na.rm = TRUE)), "miles"),
            paste0("Commutes Saved; Week of ", max(dat$Week)),
            icon = icon("map-marked", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$weekly_minutes <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            paste(comma(sum(dat$Teleworker.average.one.way.commute.minutes[dat$Week == max(dat$Week)] * 
                                dat$Telework.days[dat$Week == max(dat$Week)] * 2, 
                            na.rm = TRUE) / 60), "hours"),
            paste0("Time Saved; Week of ", max(dat$Week)),
            icon = icon("stopwatch", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$weekly_gallons <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            paste(comma(sum(dat$Teleworker.average.one.way.commute.miles[dat$Week == max(dat$Week)] * 
                                dat$Telework.days[dat$Week == max(dat$Week)] * 2, 
                            na.rm = TRUE) / 24.4), "gallons"),
            paste0("Gas Saved; Week of ", max(dat$Week)),
            icon = icon("burn", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$weekly_carbon <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            paste(comma(sum(dat$Teleworker.average.one.way.commute.miles[dat$Week == max(dat$Week)] * 
                                dat$Telework.days[dat$Week == max(dat$Week)] * 2, 
                            na.rm = TRUE) / 24.4 / 112.5), "metric tons"),
            paste0("CO2 Avoided; Week of ", max(dat$Week)),
            icon = icon("smog", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$weekly_flights <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            paste(comma(sum(dat$Teleworker.average.one.way.commute.miles[dat$Week == max(dat$Week)] * 
                                dat$Telework.days[dat$Week == max(dat$Week)] * 2, 
                            na.rm = TRUE) / 24.4 / 112.5 / 1.16), "Round Trips"),
            paste0("CO2 Equivalent of Flying Round Trip from JFK to SFO"),
            icon = icon("plane", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$weekly_trees <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        # 435: https://www.state.sc.us/forest/nurspa.htm
        # 64 Trees per Ton of Carbon: https://savingnature.com/offset-your-carbon-footprint-carbon-calculator/
        valueBox(
            paste(comma((sum(dat$Teleworker.average.one.way.commute.miles[dat$Week == max(dat$Week)] * 
                                dat$Telework.days[dat$Week == max(dat$Week)] * 2, 
                            na.rm = TRUE) / 24.4 / 112.5) * 64), "Trees"),
            paste0("Number of Trees Needed to Offset CO2 Emissions"),
            icon = icon("tree", lib = "font-awesome"),
            color = "light-blue"
        )
    })

    #############################
    ## COMMULATIVE ORG SAVINGS ##
    ##      VALUE BOXES        ##
    #############################
    
    output$total_miles <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            paste(comma(sum(dat$Teleworker.average.one.way.commute.miles * 
                                dat$Telework.days * 2, 
                            na.rm = TRUE)), "miles"),
            paste0("Commutes Saved"),
            icon = icon("map-marked", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$total_minutes <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            paste(comma(sum(dat$Teleworker.average.one.way.commute.minutes * 
                                dat$Telework.days * 2, 
                            na.rm = TRUE) / 60), "hours"),
            paste0("Time Saved"),
            icon = icon("stopwatch", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$total_gallons <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            paste(comma(sum(dat$Teleworker.average.one.way.commute.miles * 
                                dat$Telework.days * 2, 
                            na.rm = TRUE) / 24.4), "gallons"),
            paste0("Gas Saved"),
            icon = icon("burn", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$total_carbon <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            paste(comma(sum(dat$Teleworker.average.one.way.commute.miles * 
                                dat$Telework.days * 2, 
                            na.rm = TRUE) / 24.4 / 112.5), "metric tons"),
            paste0("CO2 Avoided"),
            icon = icon("smog", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$total_flights <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        valueBox(
            paste(comma(sum(dat$Teleworker.average.one.way.commute.miles * 
                                dat$Telework.days * 2, 
                            na.rm = TRUE) / 24.4 / 112.5 / 1.16), "Round Trips"),
            paste0("CO2 Equivalent of Flying Round Trip from JFK to SFO"),
            icon = icon("plane", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    output$total_trees <- renderValueBox({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        # 435: https://www.state.sc.us/forest/nurspa.htm
        # 64 Trees per Ton of Carbon: https://savingnature.com/offset-your-carbon-footprint-carbon-calculator/
        valueBox(
            paste(comma((sum(dat$Teleworker.average.one.way.commute.miles * 
                                 dat$Telework.days * 2, 
                             na.rm = TRUE) / 24.4 / 112.5) * 64), "Trees"),
            paste0("Number of Trees Needed to Offset CO2 Emissions"),
            icon = icon("tree", lib = "font-awesome"),
            color = "light-blue"
        )
    })
    
    ############
    ## GAUGES ##
    ############
    
    output$elgible_for_telework_freq <- renderGauge({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        value <- sum(dat$Telework.eligible.staff[dat$Week == max(dat$Week)])
        min <- 0
        max <- sum(dat$All.Staff[dat$Week == max(dat$Week)])
        gauge(value,
              min,
              max,
              sectors = gaugeSectors(success = c(max * 0.8, max),
                                     warning = c(max * 0.5, max * 0.8),
                                     danger = c(min, max * 0.5),
                                     colors = c("#2774AE","#FFD100", "#B71234")),
              label = "Teleworkers")
    })
    
    output$elgible_for_telework_prop <- renderGauge({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        value <- round(sum(dat$Telework.eligible.staff[dat$Week == max(dat$Week)]) / 
                                   sum(dat$All.Staff[dat$Week == max(dat$Week)]), 4) * 100
        min <- 0
        max <- 100
        gauge(value,
              min,
              max, 
              symbol = "%",
              sectors = gaugeSectors(success = c(80, 100),
                                     warning = c(50, 80),
                                     danger = c(0, 50),
                                     colors = c("#2774AE","#FFD100", "#B71234")),
              label = "Prop. of Total Workers")
    })
    
    output$people_teleworking_prop <- renderGauge({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        value <- round(sum(dat$Full.time.teleworkers[dat$Week == max(dat$Week)] + 
                               dat$Part.time.teleworkers[dat$Week == max(dat$Week)]) / 
                           sum(dat$Telework.eligible.staff[dat$Week == max(dat$Week)]), 4) * 100
        min <- 0
        max <- 100
        gauge(value,
              min,
              max, 
              symbol = "%",
              sectors = gaugeSectors(success = c(80, 100),
                                     warning = c(50, 80),
                                     danger = c(0, 50),
                                     colors = c("#2774AE","#FFD100", "#B71234")),
              label = "People Teleworking")
    })
    
    output$telework_rate <- renderGauge({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        value <- round(sum(dat$Telework.days[dat$Week == max(dat$Week)]) / 
                           sum(dat$Working.days[dat$Week == max(dat$Week)]), 4) * 100
        min <- 0
        max <- 100
        gauge(value,
              min,
              max, 
              symbol = "%",
              sectors = gaugeSectors(success = c(80, 100),
                                     warning = c(50, 80),
                                     danger = c(0, 50),
                                     colors = c("#2774AE","#FFD100", "#B71234")),
              label = "Telework Rate")
    })
        
    ###########
    ## PLOTS ##
    ###########
    
    output$elig_vs_nonelig <- renderPlot({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        tmp <- melt(dat, id.vars = c("Week"), 
                    measure.vars = c("Telework.eligible.staff", "not_elig"))
        
        tmp$variable = ifelse(tmp$variable == "Telework.eligible.staff", 
                              "Eligible for Telework", 
                              "Ineligible for Telework")
        
        ggplot(data = tmp, aes(x = Week, group = factor(variable, 
                                                        levels = c("Ineligible for Telework", 
                                                                   "Eligible for Telework")), y = value, 
                               fill = variable)) + 
            geom_bar(stat = "identity") + 
            scale_fill_manual(values = c("#2774AE","#FFD100")) + 
            scale_y_continuous(labels = comma_format(), name = "Number of Staff") +
            theme(legend.position = "top", legend.title = element_blank(),
                  panel.background = element_blank(), 
                  panel.grid.major.y = element_line(color = "light gray"), 
                  panel.grid.major.x = element_blank(), 
                  axis.ticks = element_line(color = "light gray"),
                  text = element_text(size = 20), 
                  axis.title.x = element_blank())
    })
    
    output$elig_vs_nonelig_prop <- renderPlot({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        tmp <- melt(dat, id.vars = c("Week"), 
                    measure.vars = c("Telework.eligible.staff", "not_elig"))
        
        tmp$variable = ifelse(tmp$variable == "Telework.eligible.staff", 
                              "Eligible for Telework", 
                              "Ineligible for Telework")
        
        ggplot(data = tmp, aes(x = Week, group = factor(variable, 
                                                        levels = c("Ineligible for Telework", 
                                                                   "Eligible for Telework")), y = value, 
                               fill = variable)) + 
            geom_bar(stat = "identity", position = "fill") + 
            scale_fill_manual(values = c("#2774AE","#FFD100")) + 
            scale_y_continuous(labels = percent_format(), name = "Number of Staff") +
            theme(legend.position = "top", legend.title = element_blank(),
                  panel.background = element_blank(), 
                  panel.grid.major.y = element_line(color = "light gray"), 
                  panel.grid.major.x = element_blank(), 
                  axis.ticks = element_line(color = "light gray"),
                  text = element_text(size = 20), 
                  axis.title.x = element_blank())
    })
    
    output$telework_breakdown_prop <- renderPlot({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        tmp <- melt(dat, id.vars = c("Week"), 
                    measure.vars = c("Full.time.teleworkers", 
                                     "Part.time.teleworkers",
                                     "not_tele"))
        
        tmp$variable = case_when(
            tmp$variable == "Full.time.teleworkers" ~ "Full-time", 
            tmp$variable == "Part.time.teleworkers" ~ "Part-time", 
            1 == 1 ~ "Not Teleworking")
        
        ggplot(data = tmp, aes(x = Week, 
                               group = factor(variable, levels = c("Not Teleworking", 
                                                                   "Part-time",
                                                                   "Full-time")), 
                               y = value, 
                               fill = factor(variable, levels = c("Full-time", 
                                                                  "Part-time",
                                                                  "Not Teleworking")))) + 
            geom_bar(stat = "identity", position = "fill") + 
            scale_fill_manual(values = c("#2774AE","#FFD100", "#B71234")) + 
            scale_y_continuous(labels = percent_format(), name = "Number of Staff") +
            theme(legend.position = "top", legend.title = element_blank(),
                  panel.background = element_blank(), 
                  panel.grid.major.y = element_line(color = "light gray"), 
                  panel.grid.major.x = element_blank(), 
                  axis.ticks = element_line(color = "light gray"),
                  text = element_text(size = 20), 
                  axis.title.x = element_blank())
    })
    
    output$telework_breakdown <- renderPlot({
        dat <- get_data()
        
        dat <- if("ALL" %in% input$agencies) {
            dat
        } else {
            dat[dat$Department %in% input$agencies, ]
        }
        
        tmp <- melt(dat, id.vars = c("Week"), 
                    measure.vars = c("Full.time.teleworkers", 
                                     "Part.time.teleworkers",
                                     "not_tele"))
        
        tmp$variable = case_when(
            tmp$variable == "Full.time.teleworkers" ~ "Full-time", 
            tmp$variable == "Part.time.teleworkers" ~ "Part-time", 
            1 == 1 ~ "Not Teleworking")
        
        ggplot(data = tmp, aes(x = Week, 
                               group = factor(variable, levels = c("Not Teleworking", 
                                                                   "Part-time",
                                                                   "Full-time")), 
                               y = value, 
                               fill = factor(variable, levels = c("Full-time", 
                                                                  "Part-time",
                                                                  "Not Teleworking")))) + 
            geom_bar(stat = "identity") + 
            scale_fill_manual(values = c("#2774AE","#FFD100", "#B71234")) + 
            scale_y_continuous(labels = comma_format(), name = "Number of Staff") +
            theme(legend.position = "top", legend.title = element_blank(),
                  panel.background = element_blank(), 
                  panel.grid.major.y = element_line(color = "light gray"), 
                  panel.grid.major.x = element_blank(), 
                  axis.ticks = element_line(color = "light gray"),
                  text = element_text(size = 20), 
                  axis.title.x = element_blank())
    })

    output$telework_commute_distance_hist <- renderPlot({
        dat <- get_other_dat()
        
        dat <- dat[dat$tele_class != "Not Telework Eligible" & 
                       dat$X1.Way.Commute.Miles > 0 &
                       dat$X1.Way.Commute.Miles <= 100, ]
        
        ggplot(dat, aes(x = X1.Way.Commute.Miles, 
                        fill = factor(tele_class, 
                                      levels = c("No Telework", 
                                                 "Partial Telework", 
                                                 "Full Telework")))) + 
            geom_histogram(binwidth = 5, color = "white") + 
            ylab("Telework Eligible Employees") + 
            xlab("One-Way Commute Distance (miles)") +
            scale_fill_manual(values = c("#B71234","#FFD100", "#2774AE")) +
            theme(legend.position = "top", legend.title = element_blank(),
                  panel.background = element_blank(), 
                  panel.grid.major.y = element_line(color = "light gray"), 
                  panel.grid.major.x = element_blank(), 
                  axis.ticks = element_line(color = "light gray"),
                  text = element_text(size = 20))
    })
    
    output$telework_commute_minutes_hist <- renderPlot({
        dat <- get_other_dat()
        
        dat <- dat[dat$tele_class != "Not Telework Eligible" & 
                       dat$X1.Way.Commute.Miles > 0 &
                       dat$X1.Way.Commute.Miles <= 100, ]
        
        ggplot(dat, aes(x = X1.Way.Commute.Minutes, 
                        fill = factor(tele_class, 
                                      levels = c("No Telework", 
                                                 "Partial Telework", 
                                                 "Full Telework")))) + 
            geom_histogram(binwidth = 5, color = "white") + 
            ylab("Telework Eligible Employees") + 
            xlab("One-Way Commute Time (minutes)") +
            scale_fill_manual(values = c("#B71234","#FFD100", "#2774AE")) +
            theme(legend.position = "top", legend.title = element_blank(),
                  panel.background = element_blank(), 
                  panel.grid.major.y = element_line(color = "light gray"), 
                  panel.grid.major.x = element_blank(), 
                  axis.ticks = element_line(color = "light gray"),
                  text = element_text(size = 20))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
