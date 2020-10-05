#Code for JLE Revisions; Comment 10 on market access and population density
#Author: Noel Johnson
#Created: 7/25/19
#Last Edited: 8/31/20 (for replication files for JLE publication)

#The goal is to, for every district, calculate the distance to cities of different size classes.

#install.packages("nngeo")

library(raster)
library(sf)
library(tidyverse)
library(tmap)
library(skimr)
library(haven)
library(nngeo)

setwd("/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/Cities_Bins_Comment_10")

#Bring in districts shape file.
#define the projection
EEC <- "+proj=eqdc +lat_0=0 +lon_0=0 
+lat_1=43 +lat_2=62 +x_0=0 +y_0=0 +ellps=intl +units=m +no_defs"
districts <- st_read("French_Districts/District_proj_3.shp")
#file.exists("French_Districts/District_proj_3.shp")
districts_proj <- st_transform(districts, EEC)
head(districts_proj)
glimpse(districts_proj)
districts_proj <- select(districts_proj, c(geometry,ID,districtna))
districts_proj <- rename(districts_proj,id=ID)
districts_sorted <- arrange(districts_proj,id)
head(districts_sorted)

districts_map <- tm_shape(districts_proj) + tm_borders(col = "black")
tmap_save(districts_map, "districts_map.pdf")
#districts_map

##Bring in Bairoch data on city pops.
cities <- read_dta("Bairoch_Cities/Base Jewish Cities Data Final.dta")
cities <- filter(cities, year==1800)
cities <- select(cities,c(Bairoch_id,chandlerpop,pop,pop_bairoch,year,longitude,latitude))
cities_spatial <- st_as_sf(cities, coords = c("longitude", "latitude"), crs = 4326)
cities_proj <- st_transform(cities_spatial, EEC)
head(cities_proj)
glimpse(cities_proj)
#plot(cities_proj[6], reset = FALSE)

test <- st_join(cities_proj, districts_sorted)
test <- test %>% filter(id!="NA")
plot(test[6], reset=T)

#cities_map <- tm_shape(cities_proj) + tm_dots() + districts_map
#cities_map

#Analyze Bairoch data to get a sense for what the bins should look like.
skim(cities_proj$pop)
skim(test$pop)
#The difference between the two is that test uses just cities within french districts, cities_proj uses all cities in the Barioch sample. The differences don't seem to be that great. 

#It looks like the interquartile ranges are: 1-5, 5-7, 7-11, and 11-948

#Model the bishops data a little bit

#Import the bishops data
bishoprics <- st_read("Bishoprics/Bishopric1600Proj.shp")
bishoprics_proj <- st_transform(bishoprics, EEC)
head(bishoprics_proj)
glimpse(bishoprics_proj)
#bishoprics_map <- tm_shape(bishoprics_proj) + tm_dots()
#bishoprics_map

#Crop bishoprics data
bishoprics_proj
#Original Extent of bishoprics c(xmin=-802375.3, xmax=5825227, ymin=3042218, ymax=6890422))
bishoprics_clip <- st_crop(bishoprics_proj, c(xmin=-1100000, xmax=1655719, ymin=3243609, ymax=6800000))
bishoprics_clip

#Link with nearest Bairoch city
#Make a map of bishoprics and Bairoch cities together
cities_map <- tm_shape(cities_proj) + tm_dots(size = .05)
bishoprics_map <- tm_shape(bishoprics_clip) + tm_symbols(shape = 1, size = .25, col = "blue") + cities_map
bishoprics_map

#Make the linkages
#Joining the bishoprics to barioch cities with a tolerance of 3kms
sel <- st_join(bishoprics_clip, cities_proj, st_nn, k = 1, maxdist = 3000)
sel <- sel %>% drop_na(c(year,pop))
l = st_connect(sel, cities_proj)
plot(st_geometry(sel), col = "darkgrey")
plot(st_geometry(l), add = TRUE)
plot(st_geometry(cities_proj), col = "red", add = TRUE)

#Create data set with largest bishoprics by population excluded
#Make three data sets: (1) bishoprics below the last quartile (excluding 4th---i.e. largest---quartile) in population in 1800; (2) bishoprics below the median in population in 1800; (3) bishoprics in the first quartile (<5)

#(1) bishoprics below the last quartile in population in 1800
skim(sel$pop)
head(sel)
small_bishoprics <- sel %>% filter(pop <= 21)
skim(small_bishoprics)
plot(st_geometry(small_bishoprics), col = "darkgrey", add = FALSE)
bishoprics_map <- tm_shape(bishoprics_clip) + tm_symbols(shape = 1, size = .25, col = "black")
small_bishoprics_map <- tm_shape(small_bishoprics) + tm_dots(size = 0.05, col="blue") + bishoprics_map
small_bishoprics_map

#Find the distance to these "small" bishoprics to the districts in your base data set.
distances_small_bishoprics <- st_nn(districts_proj, small_bishoprics, returnDist = TRUE, k = 1)
distances_small_bishoprics$dist
distances_small_bishoprics <- unlist(distances_small_bishoprics$dist, use.names = FALSE)
distances_small_bishoprics
districts_small_bishoprics <- add_column(districts_proj,distances_small_bishoprics)

glimpse(districts_small_bishoprics)
districts_small_bishoprics <- districts_small_bishoprics %>%
  mutate(dist_small_bishop=as.numeric(distances_small_bishoprics))

districts_small_bishoprics <- select(districts_small_bishoprics, c(id,dist_small_bishop))

head(districts_small_bishoprics)
skim(districts_small_bishoprics)

districts_small_bishoprics <- st_drop_geometry(districts_small_bishoprics)

write_delim(districts_small_bishoprics, "dist_small_bishops", na = ".", append = FALSE, col_names = TRUE, delim = ";")


#(2) bishoprics below the median in population in 1800
skim(sel$pop)
#median pop is 13
head(sel)
small_bishoprics <- sel %>% filter(pop <= 13)
skim(small_bishoprics)
plot(st_geometry(small_bishoprics), col = "darkgrey", add = FALSE)
bishoprics_map <- tm_shape(bishoprics_clip) + tm_symbols(shape = 1, size = .25, col = "black")
small_bishoprics_map <- tm_shape(small_bishoprics) + tm_dots(size = 0.05, col="blue") + bishoprics_map
small_bishoprics_map

#Find the distance to these "small" bishoprics to the districts in your base data set.
distances_small_bishoprics <- st_nn(districts_proj, small_bishoprics, returnDist = TRUE, k = 1)
distances_small_bishoprics$dist
distances_small_bishoprics <- unlist(distances_small_bishoprics$dist, use.names = FALSE)
distances_small_bishoprics
districts_small_bishoprics <- add_column(districts_proj,distances_small_bishoprics)

glimpse(districts_small_bishoprics)
districts_small_bishoprics <- districts_small_bishoprics %>%
  mutate(dist_very_small_bishop=as.numeric(distances_small_bishoprics))

districts_small_bishoprics <- select(districts_small_bishoprics, c(id,dist_very_small_bishop))

head(districts_small_bishoprics)
skim(districts_small_bishoprics)

districts_small_bishoprics <- st_drop_geometry(districts_small_bishoprics)

write_delim(districts_small_bishoprics, "dist_very_small_bishops", na = ".", append = FALSE, col_names = TRUE, delim = ";")



# (3) bishoprics in the first quartile (<5)
skim(sel$pop)
# first quartile (<=5)
head(sel)
small_bishoprics <- sel %>% filter(pop <= 5)
skim(small_bishoprics)
plot(st_geometry(small_bishoprics), col = "darkgrey", add = FALSE)
bishoprics_map <- tm_shape(bishoprics_clip) + tm_symbols(shape = 1, size = .25, col = "black")
small_bishoprics_map <- tm_shape(small_bishoprics) + tm_dots(size = 0.05, col="blue") + bishoprics_map
small_bishoprics_map

#Find the distance to these "small" bishoprics to the districts in your base data set.
distances_small_bishoprics <- st_nn(districts_proj, small_bishoprics, returnDist = TRUE, k = 1)
distances_small_bishoprics$dist
distances_small_bishoprics <- unlist(distances_small_bishoprics$dist, use.names = FALSE)
distances_small_bishoprics
districts_small_bishoprics <- add_column(districts_proj,distances_small_bishoprics)

glimpse(districts_small_bishoprics)
districts_small_bishoprics <- districts_small_bishoprics %>%
  mutate(dist_very_small_bishop=as.numeric(distances_small_bishoprics))

districts_small_bishoprics <- select(districts_small_bishoprics, c(id,dist_very_small_bishop))

head(districts_small_bishoprics)
skim(districts_small_bishoprics)

districts_small_bishoprics <- st_drop_geometry(districts_small_bishoprics)

districts_small_bishoprics <- districts_small_bishoprics %>% rename(dist_bishop_first_quartile=dist_very_small_bishop)

write_csv(districts_small_bishoprics, "dist_first_quartile_bishops.csv", na = ".", col_names = TRUE)



#Export these distances to stata to run regressions.


#Create separate shape files for the different population bins.
cities_Q1 = cities_proj %>% filter(pop < 5)
cities_Q2 = cities_proj %>% filter(pop >= 5 & pop < 7)
cities_Q3 = cities_proj %>% filter(pop >= 7 & pop < 11)
cities_Q4 = cities_proj %>% filter(pop >= 11)

cities_map_Q1 <- tm_shape(cities_Q1) + tm_dots() + districts_map
cities_map_Q1
cities_map_Q2 <- tm_shape(cities_Q2) + tm_dots() + districts_map
cities_map_Q2
cities_map_Q3 <- tm_shape(cities_Q3) + tm_dots() + districts_map
cities_map_Q3
cities_map_Q4 <- tm_shape(cities_Q4) + tm_dots() + districts_map
cities_map_Q4

#Calculate distances for each district for each bin-shape file.
distances_Q1 <- st_nn(districts_proj, cities_Q1, returnDist = TRUE, k = 1)
distances_Q1$dist
distances_Q1 <- unlist(distances_Q1$dist, use.names = FALSE)
distances_Q1
districts_Q1234 <- add_column(districts_proj,distances_Q1)

distances_Q2 <- st_nn(districts_proj, cities_Q2, returnDist = TRUE, k = 1)
distances_Q2$dist
distances_Q2 <- unlist(distances_Q2$dist, use.names = FALSE)
distances_Q2
districts_Q1234 <- add_column(districts_Q1234,distances_Q2)

distances_Q3 <- st_nn(districts_proj, cities_Q3, returnDist = TRUE, k = 1)
distances_Q3$dist
distances_Q3 <- unlist(distances_Q3$dist, use.names = FALSE)
distances_Q3
districts_Q1234 <- add_column(districts_Q1234,distances_Q3)

distances_Q4 <- st_nn(districts_proj, cities_Q4, returnDist = TRUE, k = 1)
distances_Q4$dist
distances_Q4 <- unlist(distances_Q4$dist, use.names = FALSE)
distances_Q4
districts_Q1234 <- add_column(districts_Q1234,distances_Q4)

districts_Q1234 <- districts_Q1234 %>%
  mutate(distances_Q1=as.numeric(distances_Q1)) %>%
  mutate(distances_Q2=as.numeric(distances_Q2)) %>%
  mutate(distances_Q3=as.numeric(distances_Q3)) %>%
  mutate(distances_Q4=as.numeric(distances_Q4))

#Save the quartile data

head(districts_Q1234)
skim(districts_Q1234)

districts_Q1234 <- select(districts_Q1234, c(id,distances_Q1,distances_Q2,distances_Q3,distances_Q4))

districts_Q1234 <- st_drop_geometry(districts_Q1234)

write_delim(districts_Q1234, "districts_Q1234", na = ".", append = FALSE, col_names = TRUE, delim = ";")

#Merge in the distances to the main data set.
#Do this in stata since that's where the .do file is set up.

#Run regressions. I assume the IV's, but also the baseline regs using the distance to population bins as controls.
#Do this in stata.

#End Code
