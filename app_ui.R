library("shiny")
source("base.R")

#Question 1 layout
birth_rates <- birth_rates %>% 
  mutate(Year = as.integer(Year)) %>% 
  filter(Year > 1994, Year < 2020) 

features <- birth_rates$Entity
radio_button_input <- radioButtons(
  inputId = "features",
  label = "Birth rate change",
  choices = c("All countries", "Countries that have birth rate increase", "Countries that have birth rate decrease or no change"))

year_input <- sliderInput(
  inputId = "year_choice" ,
  label = "Year",
  min = 1995,
  max = 2019,
  value = c(1995,2019),
  sep = "")


year_range <- range(birth_rates$Year)

sidebar_content_q1 <- sidebarPanel(
  radio_button_input,
  year_input
)

main_content_q1 <- mainPanel(
  plotOutput(outputId = "q1_plot")
)

q1_layout <- sidebarLayout(
  sidebar_content_q1,
  main_content_q1,
  position = "right"
)

#Question 2 layout
sidebar_content_q2 <- sidebarPanel(
  sliderInput(inputId = "emission_slider", label = "Pick a birth year (left) and an emissions year (right)", min = 1950, max = 2017, value = c(1997, 2017)),
  checkboxInput("outlier_check_Q2", label = "Remove outliers", value = TRUE)
)
main_content_q2 <- mainPanel(
  plotOutput("q2_plot")
)
q2_layout <- sidebarLayout(
  sidebar_content_q2,
  main_content_q2,
)

#Question 3 layout
countries_name <- unique(emissions$Entity)
main_content_q3 <- mainPanel(
  plotOutput(outputId = "q3_plot")
)

country_input <- selectInput(inputId = "country_name", 
                             label = "Select a country", 
                             choices = countries_name,
                             selected  = "Vietnam")

year_range_input <- sliderInput(inputId = "year_range", 
                                label = "Year Range", 
                                min = 1967, 
                                max = 2017, 
                                value = c(1967, 2017),
                                sep = "")

sidebar_content_q3 <- sidebarPanel(
  country_input,
  year_range_input
)

q3_layout <- sidebarLayout(
  sidebar_content_q3,
  main_content_q3,
  position = "right"
)

#Question 4 layout
sidebar_content_q4 <- sidebarPanel(
  sliderInput(inputId = "world_year_slider", label = "Pick a birth year (left) and an emissions year (right)", min = 1950, max = 2017, value = c(1993, 2011), sep = ""),
  checkboxInput("outlier_check_Q4", label = "Remove outliers", value = TRUE)
)

main_content_q4 <- mainPanel(
  plotOutput("q4_plot"),
  span(textOutput("error"), style="color:red"),
  textOutput("correlation_q4")
)

q4_layout <- sidebarLayout(
  sidebar_content_q4,
  main_content_q4
)
  
#Introduction tab
introduction <- tabPanel(
  title = "Introduction",
  h1("Welcome to Warm Babies Project"),
  p(
    "Our overall question is asking whether",
    em("birth rate across the world influences climate change."), 
    "The data sets were found through", 
    a(href = "https://ourworldindata.org/", "Our World in Data"),
    "created by UN Population Division and Global Carbon Project and demonstrate the potential worldwide correlation between birthrate and CO2 emissions. The birth rate is represented with the dataset of ",
    a(href = "https://ourworldindata.org/fertility-rate?fbclid=IwAR26nSY7EiW3eZnHdWdAfFRobNkDWA6K4Kc6p54atM6jrbt_7xJDD_MyOho", "children born per woman"), 
    "and climate change is represented through",
    a(href = "https://ourworldindata.org/co2-and-other-greenhouse-gas-emissions?fbclid=IwAR395Avylw1hiC9rkHdEqFDiHKcdSGQSqZDoArTAsaEsC1E4QAK5DCp1AaQ#annual-co2-emissions", "annual CO2 emissions per country."), 
    "The children born per woman data set finds the average fertility per woman in different countries across many years. The annual CO2 emissions per country data set locates the amount of CO2 different countries use, reflecting its effect on global warming."
  ),
  p(
    "The data sets we will be using are of the average birth rate of countries and the annual CO2 gas emission of countries. Both data sets span around a century, but have been parsed to include more recent years. The source of both data sets is published by the University of Oxford with a large amount of data backing up the research methods and original sources."
  ),
  p(
    strong("For further details on our project report and data analysis, follow the link "),
    a(href = "https://info201a-wi20.github.io/project-report-n-liang/", "here.")
  ),
  p(
    "As concerns surrounding climate change have increased in recent years, the idea of reducing the global birth rate has become a growing suggestion. Many young individuals have made decisions to not procreate or create families due to the concern of overpopulation and the depletion of environmental resources. As a group, we aimed to use data sets of global fertility rates and global rate of CO2 emissions to find correlation between the changes of the two within the last few decades or so. By drawing conclusions with analysis of these data sets, we hope to draw attention to this idea as a",
    em("potential solution to the global concern of climate change.")
  ),
  p(
    "This app was created collaboratively by Victoria Pao, Bao Nguyen, Ted Wang, and Nick Liang."
  )
)

#All questions tabs
q1_tab <- tabPanel(
  title = "Birthrate Changes around the world" ,
  titlePanel("How has the birth rate changed between 1995 and 2019 across the world?"),
  q1_layout,
  p(textOutput(outputId = "q1_analysis"))
)

q2_tab <- tabPanel(
  title = "CO2 emission around the world",
  titlePanel("How has emissions changed between 1995 and 2019 across the world?"),
  q2_layout,
  p(textOutput(outputId = "q2_analysis"))
)

q3_tab <- tabPanel(
  title = "Birth rate vs CO2 emission",
  titlePanel("Comparing a single country across 50 years in time span, how has the change in birth rate impacted emission rate growth?"),
  q3_layout,
  p(textOutput(outputId = "q3_analysis"))
)

q4_tab <- tabPanel(
  title = "Effect of birthrate on emission growth in later years",
  titlePanel("Comparing every country, how has the birth rate in a single year impacted their increase in CO2 emissions in succeeding years?"),
  q4_layout,
  p("This graph allows you to cross-sectionally analyis how birth rate in a single year is correlated with emission growths in any suceeding year.
    By examining every country, we get the largest sample size we can. This allows us to answer the question of if, in general, 
    having more children correlates with higher growth in CO2 emissions. Generally, you can find a very strong correlation between higher birth rate 
    and higher growth in CO2 emissions in subsequent years. Showing that the two are strongly linked (by social science standards")
)

my_ui <- navbarPage(
  title = "Warm Babies",
  introduction,
  q1_tab,
  q2_tab,
  q3_tab,
  q4_tab
)


