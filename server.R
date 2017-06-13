library("DT")
library("shiny")
library("httr")
library("ggplot2")
library("dplyr")

source("./scripts/SpotifyToolUpdated.R")


shinyServer(function(input, output) {
  # React as the input changes 
  country <- reactive({switch(
    input$radio,
    "1" = input$AsiaPacific,
    "2" = input$Europe,
    "3" = input$LatinAmerica,
    "4" = input$UnitedStateCanada
  )})
  
  # React and pass the input value to the function and get the data frame 
  value <- reactive({
    temp<-GetArtist(input$text)
    df<-GetTopTrack(temp$id, country())
    
    #retreive the list inside whole toptack data
    imgs<-df$album$images
    #make it into a dataframe
    my.matrix<-do.call("rbind",imgs)
    imgs.df<-as.data.frame(my.matrix, stringsAsFactors=FALSE)
    
    #filter to the smallest size picture
    imgs.df<-imgs.df %>% filter(width==64)
    #make it back to the dataframe we want to use
    df$pic<- paste0('<img src="', imgs.df$url,'" height="64"></img>')
    #retreive the name of album
    name<-df$album$name
    #paste it back to the dataframe we want to use
    df$albumname<- name
    
    #only select the stuff we want 
    df<-df %>% select(pic,albumname,name,popularity) %>% arrange(desc(popularity))
  })
  
  # stores user ID
  userID <- reactive({
    input$user_id
  })
  
  # stores playlist ID
  playlistID <- reactive ({
    input$playlist_id
  })
  
  # stores first playlist feature
  xLab <- reactive ({
    input$xlab
  })
  
  # stores second playlist feature
  yLab <- reactive({
    input$ylab
  })
  
  # grabs playlist and track info and stores neccessary information into a data frame
  data <- reactive({
    playlist.data <- GetPlaylistInfo(userID(), playlistID())
    playlist.df <- data.frame(playlist.data)
    playlist.length <- nrow(playlist.df)
    audfeat <- data.frame()
    for (i in 1:playlist.length) {
      curr <- data.frame(GetTrackInfo(playlist.df$track$id[i]))
      audfeat <- rbind(curr, audfeat)
    }
    audfeat$popularity <- paste(playlist.df$track$popularity)
    audfeat$track <- paste(playlist.df$track$name)
    audfeat <- select_(audfeat, x = xLab(), y = yLab(), 'track')
    if (ncol(audfeat) == 2) {
      audfeat <- mutate(audfeat, x = audfeat[, 1])
    }
    print(audfeat)
  })
  
  # renders plot of the playlist features selected by the user
  output$plot <- renderPlotly({
    df <- data()
    print(df)
    print(xLab())
    plot(df$x, df$y)
    plot_ly(data = df, x = ~df$x, y = ~df$y, type = 'scatter', marker = list(color = "rgb(106,227,104)"), text = ~paste("Track Name: ", df$track)) %>% 
      layout(xaxis = list(title = input$xlab), yaxis = list(title = input$ylab), title = "Playlist Features")
  }
  )
  
  
  
  
  # interactive data table
  output$view <- DT::renderDataTable({
    DT::datatable(value(),escape = FALSE, options = list(paging = FALSE, order = list(4, 'desc'), 
                                                         columnDefs = list(list(className = 'dt-center', targets = "_all"))),
                  colnames = c("Album Pic","Album Name","Song Name","Song Popularity"),class = 'cell-border stripe')
  })
  
  
  
  
})

