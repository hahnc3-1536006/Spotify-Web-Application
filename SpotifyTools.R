
library(dplyr)
library(httr)

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

# artistName <- String with name of artist. Ex.) "Beyonce"
# RETURNS: Artist object with info about artist
GetArtist <- function(artistName) {
  HeaderValue = paste0('Bearer ', GetToken())
  
  URI = paste0('https://api.spotify.com/v1/search?query=', artistName,'&offset=0&limit=20&type=artist')
  response = GET(url = URI, add_headers(Authorization = HeaderValue))
  return(content(response))
}


# Enter in a playlist id and a user id (Found at the end of the url linking to them)
# Ex.) https://open.spotify.com/user/robinyang97/playlist/5Nw4PNrW5uxTLRNndlTFe1
#      "5Nw4PNrW5uxTLRNndlTFe1" is the playlist ID
# RETURNS: A dataframe of all the tracks, their ID, and other useful info
GetTracks = function(playlist_id, user_id){
  HeaderValue = paste0('Bearer ', GetToken())
  
  URI = paste0('https://api.spotify.com/v1/users/', user_id,'/playlists/', playlist_id,'/tracks')
  response = GET(url = URI, add_headers(Authorization = HeaderValue))
  tracks = fromJSON(content(response, "text"))$items$track
  return(tracks)
}

user_id <- "robinyang97"
playlist_id <- "5Nw4PNrW5uxTLRNndlTFe1"

# Takes a track ID 
# RETURNS: Dataframe of that track's information
GetTrackInfo <- function(trackid){
  
  HeaderValue = paste0('Bearer ', GetToken())
  URI = paste0("https://api.spotify.com/v1/audio-features/", trackid)
  response = GET(url = URI, add_headers(Authorization = HeaderValue))
  as.data.frame(stringsAsFactors  = FALSE, content(response))
}

# Some test code I was messing with

ids <- paste0(test.PlayList$track$id, collapse = ", ")
testMults <- GetMultipleTrackInfo(ids)

my.playlist <- GetTracks(playlist_id, user_id)
my.tracks <- GetTrackInfo("6K4t31amVTZDgR3sKmwUJJ")



# Takes a user ID and a playlist ID
# RETURNS: Dataframe with information on playlist and tracks in playlist
GetPlaylistInfo <- function(user_id, playlist_id){
  
  HeaderValue = paste0('Bearer ', GetToken())
  URI = paste0('https://api.spotify.com/v1/users/', user_id,'/playlists/', playlist_id)
  response = GET(url = URI, add_headers(Authorization = HeaderValue))
  playlist_info = fromJSON(content(response, "text"))
  
  return(playlist_info$tracks$items)
}

