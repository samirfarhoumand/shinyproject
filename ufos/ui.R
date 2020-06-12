

shinyUI(dashboardPage(
    skin = "black",
    dashboardHeader(title = "UFO Sightings"),
    #sidebar tabs
    dashboardSidebar(
        sidebarMenu(
            menuItem("Introduction",
                     tabName = "intro",
                     icon = icon("book")),
            menuItem(
                "Geographic Analysis",
                tabName = "map",
                icon = icon("map")
            ),
            menuItem(
                "Seasonal Analysis",
                tabName = "calendar",
                icon = icon("calendar")
            ),
            menuItem(
                "Shape Analysis",
                tabName = "shape",
                icon = icon("shapes")
            ),
            menuItem(
                "Duration Analysis",
                tabName = "time",
                icon = icon("hourglass")
            ),
            menuItem("Data",
                     tabName = "data",
                     icon = icon("database"))
            
            
        )
        
    ),
    #dashboard body
    dashboardBody(
        tabItems(
            
            #introduction tab
            tabItem(tabName = "intro",
                    fluidRow(
                        box(
                            width = 10,
                            h2("Introduction: Have our sightings changed over time?"),
                            br(),
                            br(),
                            p(
                                "This exploratory data analysis examines over 60,000 UFO
                            sightings in in the US and Canada from 1910 through 2014.
                            The data is part of a larger analysis on the NUFORC UFO
                            Sightings dataset published on Kaggle."
                            ),
                            br(),
                            p("We hope to gain the following insights:"),
                            tags$li("Has the geography of sightings changed over the
                                    years?"),
                            tags$li("Has the seasonality of sightings changed over the
                                    years?"),
                            tags$li("Has the relative frequency of UFO shapes changed over the
                                    years?"),
                            tags$li(
                                "Has the average duration of encounters changed throughout the years?"
                            )
                        )
                    )),
            
            #MAP
            tabItem(
                tabName = "map",
                fluidRow(selectizeInput("year_sighting_map",
                                        "Choose Year:",
                                        choices = unique(ufos$year),
                                        selected = min(ufos$year)),
                         plotOutput("ufomap"),
                         title = "UFO Sightings by Year",
                ),
            ),
            
            #CALENDAR 
            tabItem(
                tabName = "calendar",
                fluidRow(selectizeInput("year_sighting",
                                        "Choose Year:",
                                        choices = seq(1969,2014),
                                        selected = min(ufos$year)),
                         plotOutput("appearance"),
                         box(
                             width = 10,
                             h2("Are there times of year where UFO sightings are most common?"),
                             br(),
                             br(),
                             p(
                                 "Year by year, the range of encounters by day varies dramatically. Some
                                 days such as New Years and Independence Day seem to be very popular day
                                 for encounters... possibly due to likelihood of ambiguation with fireworks."
                             ),
                             br(),
                             p("The top five dates with the highest sum-hours encounters are:"),
                             tags$li("2010-06-03: 958 hours"),
                             tags$li("1991-09-15: 767 hours"),
                             tags$li("2012-08-10: 609 hours"),
                             tags$li("2002-08-24: 609 hours"),
                             tags$li("2008-08-03: 122 hours"),
                         )
                )
            ),
            
            #SHAPE FREQUENCY 
            tabItem(
                tabName = "shape",
                fluidRow(selectizeInput("craftshape",
                                        "Choose Shape:",
                                        choices = unique(top_22_shapes),
                                        selected = "triangle"),
                         plotOutput("percentbyyear_shape"),
                        box(
                            width = 10,
                            h2("Has the relative frequency of UFO shapes changed over the
                                    years?"),
                            br(),
                            br(),
                            p(
                                "Interestingly, the incidence of certain shapes has indeed changed over
                                time. Indeed for most objects such as Changing, Chevron, Cone, Cross, Cylinder
                                Diamond, Delta, Fireball, Formation, Rectangle, Sphere, Teardrop, Unknown, 
                                the rate of incidence has remained unchanged. And with the exception of Light,
                                most other craft shapes have dwindled, particularly the infamous Disc which has
                                decreaed by a factor of 6 since Roswell."
                            )
                        )
                )
            ),
            
            #DURATION 
            tabItem(
                tabName = "time",
                fluidRow(plotOutput("duration_year"),
                         title = "Average Duration of Encounters Over Years",
                         box(
                             width = 10,
                             h2("Have the length of our encounters changed over time?"),
                             br(),
                             br(),
                             p(
                                 "The duration of the average encounter has been on the rise over
                                 the years From the 1920s the time in munutes has increased from 
                                 less than 2 minutes on average to over 30 minutes in the 2010s.
                                 As indicated there are about 12 years with average sightings longer
                                 than 200 minutes. These years are especially important to UFOologists. 
                                 "
                             )
                         )
                )
            ),
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("dt1"), width =12)))
            
        )
    )
))