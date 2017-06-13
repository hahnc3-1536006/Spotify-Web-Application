library(dplyr)
library(httr)
library(jsonlite)
# Returns the token needed to access the API
# Used to create HeaderValue
# Ex.) HeaderValue = paste0('Bearer ', GetSpotifyToken())
GetToken <- function(){
  
  clientID = 'ba7340b971c049a595b54cb4af1b266d'
  secret = '2e9fe1e67aae46fd8f9fd0e981edebde'
  
  response <- POST('https://accounts.spotify.com/api/token',
                   accept_json(),
                   authenticate(clientID, secret),
                   body=list(grant_type='client_credentials'),
                   encode='form',
                   verbose())
  
  return(content(response)$access_token)
}

# artistName <- String with name of artist. Ex.)"Drake"
# RETURNS: Artist object with info about artist
GetArtist <- function(artistName) {
  HeaderValue = paste0('Bearer ', GetToken())
  URI = paste0('https://api.spotify.com/v1/search?query=', artistName,'&offset=0&limit=20&type=artist')
  response = GET(url = URI, add_headers(Authorization = HeaderValue))
  body<-content(response)
  info<-body$artists$items
  #turn a bunch of lists into dataframe which we can access data from
  my.matrix<-do.call("rbind",info)
  my.df<-as.data.frame(my.matrix, stringsAsFactors=FALSE)
  #the values are list,turn column that we're interested into numeric/character so we can filter
  my.df$popularity<-as.numeric(my.df$popularity)
  my.df$name<-as.character(my.df$name)
  my.df$id<-as.character(my.df$id)
  #return the most popular artist (since there are too many artists with same name)
  my.df<-my.df %>% filter(popularity==max(popularity))
  return(my.df)
}

#temp<-GetArtist("Drake")
#temp$id

# Takes the artist ID(can extract from using GetArtist function) and two digit country name
# RETURNS: The top 10 tracks of the artist within the country
GetTopTrack<-function(artistID,my_country){
  HeaderValue = paste0('Bearer ', GetToken())
  URI = paste0("https://api.spotify.com/v1/artists/", artistID, "/top-tracks")
   
  #URI = paste0("https://api.spotify.com/v1/artists/", temp, "/top-tracks")
  query.params <- list(country=my_country)
  #response <- GET(uri, query = query.params)
  response = GET(url = URI,query = query.params, add_headers(Authorization = HeaderValue))
  tempo = fromJSON(content(response, "text"))
  return(tempo$tracks)
}

# Takes a user ID and a playlist ID
# RETURNS: Dataframe with information on playlist and tracks in playlist
GetPlaylistInfo <- function(user_id, playlist_id){
  HeaderValue = paste0('Bearer ', GetToken())
  URI = paste0('https://api.spotify.com/v1/users/', user_id,'/playlists/', playlist_id)
  response = GET(url = URI, add_headers(Authorization = HeaderValue))
  playlist_info = fromJSON(content(response, "text"))
  return(playlist_info$tracks$items)
}

# Takes a track ID 
# RETURNS: Dataframe of that track's information
GetTrackInfo <- function(trackid){
  
  HeaderValue = paste0('Bearer ', GetToken())
  URI = paste0("https://api.spotify.com/v1/audio-features/", trackid)
  response = GET(url = URI, add_headers(Authorization = HeaderValue))
  as.data.frame(stringsAsFactors  = FALSE, content(response))
}

