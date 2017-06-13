#find the artist id 
library(httr)
library(jsonlite)
base.uri <- "https://api.spotify.com"
ArtistID<-function(artist){
  resource <- "/v1/search"
  uri = paste0(base.uri, resource)
  #query.params <- list(q = artist, type = "artist")
  query.params <- list(q = "Beyonce", type = "artist")
  response <- GET(uri, query = query.params)
  
  artist.info <- fromJSON(content(response, "text"))
  
  artist.id <- artist.info$artists$items$id[1]
  return(artist.id)
}

#ArtistID("Beyonce")

#find the top track in certain country
CountryTopTrack<-function(id,my_country){
  resource <- paste0("/v1/artists/", id,"/top-tracks")
  uri = paste0(base.uri, resource)
  query.params <- list(country=my_country)
  response <- GET(uri, query = query.params)
  
  top.tracks <- fromJSON(content(response, "text"))
  
  return(top.tracks$tracks$name)
}
#ArtistID("Beyonce")
#CountryTopTrack(,"GI")

#CountryTopTrack(ArtistID("Beyonce"),"US")
CountryTopTrack2<-function(id,my_country){
  resource <- paste0("/v1/artists/", id,"/top-tracks")
  uri = paste0(base.uri, resource)
  query.params <- list(country=my_country)
  response <- GET(uri, query = query.params)
  
  top.tracks <- fromJSON(content(response, "text"))
  
  return(top.tracks$tracks)
}

#CountryTopTrack2("Beyonce","US")
#us<-CountryTopTrack2(ArtistID("Beyonce"),"US")


#includes 1.track name 2.album  3.popularity(sort by this) 4.link to external spotify web page 