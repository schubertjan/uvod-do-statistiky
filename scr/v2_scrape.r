library(rvest)
library(httr)
library(jsonlite)
# api call function
get_location <- function(place) {
  query_params <- list(q = paste0(place, ", UK"),
                       format = "json")
  
  # count number of requests
  n_request <- 1
  .response <- list(status_code = 0)
  
  # try a few times if we dont succeed
  while(n_request < 5 & .response$status_code != 200) {
    # return status code
    .response <- tryCatch({
      GET("https://nominatim.openstreetmap.org/search?", query = query_params)
    }, error = function(e) 404)
    # respect the limit
    Sys.sleep(2)
    n_request <- n_request + 1
    
    if(.response$status_code == 200) {
      # extract the data
      .location <- content(.response)
      # if the location is empty
      .result <- tryCatch({
        .importnance <- sapply(.location, function(x) x[["importance"]])
        
        # select the location with highest importance
        .location <- .location[[which.max(.importnance)]]
        
        # extract info
        data.frame(lat = as.numeric(.location$lat), 
                   lon = as.numeric(.location$lon), 
                   display_name = .location$display_name, 
                   importance = .location$importance)  
      }, error = function(e) {
        data.frame(lat = NA, 
                   lon = NA, 
                   display_name = NA, 
                   importance = NA)
      })  
      
    } else {
    .result <- data.frame(lat = NA, 
                          lon = NA, 
                          display_name = NA, 
                          importance = NA) 
  }  
}

return(.result)
}

# scrape
.html <- read_html("https://www.wrsonline.co.uk/big-ben-rocket-strikes/full-list-of-v2-incidents/")
v2_location <- .html %>%
  html_nodes(".row-hover") %>%
  html_table()

# clean
v2_location <- as.data.frame(v2_location[[1]])
v2_location <- v2_location[, c(2, 3, 4)]
colnames(v2_location) <- c("date", "time", "landing_site")


df <- data.frame(matrix(NA, ncol = 4))
colnames(df) <- c("lat", "lon", "display_name", "importance")

# call the api 
for(i in 1:20) {
  .df <- get_location(place = v2_location$landing_site[i])
  df <- rbind.data.frame(df, .df)
}
# remove fisrt missing observation
df <- df[-1, ]

# london sites
london_sites <- c("London Bridge", "Buckingham Palace", "Big Ben", "Kensington Palace", "St. Paul's Cathedral", "Tower of London")
df_sites <- data.frame(matrix(NA, ncol = 4))
colnames(df_sites) <- c("lat", "lon", "display_name", "importance")
for(i in 1:length(london_sites)) {
  .df <- get_location(place = london_sites[i])
  df_sites <- rbind.data.frame(df_sites, .df)
}
df_sites <- df_sites[-1, ]

#plot
plot(df$lon, df$lat, 
     xlim = c(-0.646009, 0.362430), 
     ylim = c(51.250288, 51.736031),
     xlab = "Longitude", ylab = "Latitude",
     pch = 19,
     col = adjustcolor("black", alpha = 0.5),
     main = "Greater London")
# add london sites
points(df_sites$lon, 
       df_sites$lat, 
       pch = 19, 
       col = adjustcolor("red", alpha = 0.5))
text(x = df_sites$lon, y = df_sites$lat,
     labels = london_sites, 
     pos = 3, cex = 0.7)  
