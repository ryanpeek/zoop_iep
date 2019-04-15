suppressPackageStartupMessages({
  library(tidyverse);
  library(shiny);
  library(shinyBS)
  library(shinythemes);
  library(leaflet);
  library(sf);
  library(purrr);
  library(lubridate);
  library(naniar)
  })

# load data
load("data/cb_iep_full.rda")

# filter data:
cb_filt <- cb_full %>% dplyr::select(SurveyCode:Station,Current,Location,Y_Start, Y_End, lat,lon, Region:Temperature, CBVolume:CRABZOEA) %>% 
  group_by(Station) %>% 
  mutate(minDate = min(Date),
         maxDate = max(Date)) %>% 
  ungroup

# make variable choices
varNames <- cb_filt %>% as.data.frame() %>% select(-geometry) 
varNames <- names(varNames[,18:73])

# make site choices
site_choices <- setNames(unique(cb_filt$Station),unique(cb_filt$Station))

# make map dataset
cb_filt_stations <- cb_filt %>% 
  select(Station, Region, Location, Current,  Y_Start, Y_End, lat, lon) %>% 
  as.data.frame() %>% select(-geometry) %>% distinct(.keep_all = TRUE) %>%
  st_as_sf(coords=c("lon","lat"), crs=4326, remove=F)


# test map
# leaflet() %>%
# 
#   setView(lng = -121.75, lat=38.07, zoom = 9) %>%
#   addProviderTiles("Esri.WorldImagery", group = "ESRI Aerial") %>%
#   addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
#   addProviderTiles("OpenStreetMap.BlackAndWhite", group = "OpenBW") %>%
#   addProviderTiles("Esri.WorldGrayCanvas", group="ESRI Canvas") %>%
#   
#   # add scale bar and home
#   addMeasure(position = "topright",
#              primaryLengthUnit = "meters",
#              primaryAreaUnit = "sqmeters",
#              activeColor = "#3D535D",
#              completedColor = "#7D4479") %>%
#   #   
#   # add markers
#   addCircleMarkers(data=cb_filt_stations, group="Stations",
#                    layerId = ~Station,
#                    radius = 8, color = "white", fillColor = "purple",
#                    weight= 1, fillOpacity=0.7,
#                    popup = paste0("Station: ", cb_filt_stations$Station,
#                                   "<br> Lon: ", cb_filt_stations$lon,
#                                   "<br> Lat: ", cb_filt_stations$lat,
#                                   "<br> Type: ", cb_filt_stations$Location,
#                                   "<br> YrStart: ", cb_filt_stations$Y_Start,
#                                   "<br> YrEnd: ", cb_filt_stations$Y_End)) %>%
#   #addLegend(pal = col_pal, values = c(min_obs, max_obs), title = "log(Cladocerans)") %>%
#   #addControl(paste0(month, "-", year), position = "bottomleft") %>% 
#   addLayersControl(
#     baseGroups = c("ESRI Canvas", "OpenBW",
#                    "Topo","ESRI Aerial"),
#     overlayGroups = c("Stations"),
#     options = layersControlOptions(collapsed = T))
