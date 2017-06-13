library(shiny)
library(dplyr)
library(plotly)
library(markdown)
shinyUI(
  navbarPage(img(src='myimage.png',width = "30", height = "30"),theme = "bootstrap.css",
             tabPanel("Popularity By Region",
                      titlePanel("Top Ten Tracks by Region"),
                      
                      
                      sidebarPanel(
                        textInput("text", label = h3("Search Artists"),value = "Beyonce"),
                        helpText("This version does not support characters with space"),
                        radioButtons("radio", label = h3("Select Region"),
                                     choices = list("Asia Pacific" = "1", "Europe" = "2", "Latin America" = "3", "United States and Canada" = "4")),
                        conditionalPanel(condition = "input.radio == '1'",
                                         selectInput("AsiaPacific", "Select Country",choices = c("Australia" = "AU", "Japan" = "JP", "Hong Kong" = "HK", "Indonesia" = "ID","Malaysia" = "MY","New Zealand" = "NZ","Philippines" = "PH","Singapore" = "SG","Taiwan" = "TW"))),
                        conditionalPanel(condition = "input.radio == '2'",
                                         selectInput("Europe", "Select Country",choices = c("Andorra" = "AD", "Austria" = "AT","Belgium" = "BE", "Bulgaria" = "BG","Cyprus" = "CY","Czech Republic" = "CZ","Denmark" = "DK","Estonia" = "EE","Finland" = "FI","France" = "FR","Germany" = "DE","Greece" = "GR","Hungary" = "HU"
                                                                                            ,"Iceland" = "IS","Ireland" = "IE","Italy" = "IT","Latvia" = "LV","Liechtenstein" = "LI","Lithuania" = "LT","Luxembourg" = "LU","Malta" = "MT","Monaco" = "MC","Netherlands" = "NL","Norway" = "NO","Poland" = "PL","Portugal" = "PT"
                                                                                            ,"Slovakia" = "SK","Spain" = "ES","Sweden" = "SE","Switzerland" = "CH","Turkey" = "TR","United Kingdom" = "UK"))),
                        conditionalPanel(condition = "input.radio == '3'",
                                         selectInput("LatinAmerica", "Select Country",choices = c("Argentina" = "AR", "Bolivia" = "BO", "Brazil" = "BR", "Chile" = "CL","Colombia" = "CO","Costa Rica" = "CR","Dominican Republic" = "DO","Ecuador" = "EC", "El Salvador" = "SV","Guatemala" = "GT","Honduras" = "HN","Mexico
                                                                                                  " = "MX","Nicaragua" = "NI","Panama" = "PA","Paraguay" = "PY","Peru" = "PE","Uruguay" = "UY"))),
                        conditionalPanel(condition = "input.radio == '4'",
                                         selectInput("UnitedStateCanada", "Select Country", choices = c("United States" = "US", "Canada" = "CA"))
                        )
                        
                                         ),
                      mainPanel(
                        DT::dataTableOutput('view')
                      )
  ),
  tabPanel("Playlist Features",
           titlePanel("Spotify Playlist Features"),
           
           
           sidebarPanel(
             textInput("user_id", label = h3("User ID"), value = "robinyang97"),
             
             textInput("playlist_id", label = h3("Playlist ID"), value = "3K7wVvlGazwHph6M5h6VjG"),
             
             selectInput("xlab", "X-axis", c("danceability", "energy", "speechiness", "acousticness", "liveness", "valence", "tempo", "popularity", "duration_ms")),
             
             selectInput("ylab", "Y-axis", c("danceability", "energy", "speechiness", "acousticness", "liveness", "valence", "tempo", "popularity", "duration_ms"))
             
             
           ),
           mainPanel(
             plotlyOutput("plot")
           )
  ),
  tabPanel("Documentation",
           mainPanel(includeMarkdown("./markdown/README.md")
                     
           )
  ))
)




