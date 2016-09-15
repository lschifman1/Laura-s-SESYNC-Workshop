# Libraries
library(ggplot2)
library(dplyr)

# Data
species <- read.csv("data/species.csv", stringsAsFactors = FALSE)
surveys <- read.csv("data/surveys.csv", na.strings = "", stringsAsFactors = FALSE)

# User Interface
in1 <- selectInput("pick_species",
                   label = "Pick a species",
                   choices = unique(species[["species_id"]]))
out1 <- textOutput("species_name")
out2 <- plotOutput("species_plot")
out3 <- tableOutput("species_table")
side <- sidebarPanel("Options", in1, out1)
main <- mainPanel(out2,out3)
tab <- tabPanel("Species", 
                sidebarLayout(side, main))
ui <- navbarPage(title = "Portal Project", tab)

# Server
server <- function(input, output) {
  output[["species_name"]] <- renderText(
    species  %>%
      filter(species_id == input[["pick_species"]]) %>% 
      select(genus, species) %>%
      paste(collapse = ' ')
  )
  output[["species_plot"]] <- renderPlot(
    surveys  %>%
      filter(species_id == input[["pick_species"]]) %>%
      ggplot(aes(year)) +
      geom_bar()
  )
  output[["species_table"]] <-renderTable(
    surveys %>% filter(species_id == input[["pick_species"]]) %>% 
      summarize(species_id, year)
  )
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
