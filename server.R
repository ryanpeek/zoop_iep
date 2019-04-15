
#dynamic_server
shinyServer(function(input, output, session) {
  
  # Tab1: get stations 
  datasetInput <- reactive({
    switch(input$station,
           cb_dat <- dplyr::filter(cb_filt, Station==input$station))
  })
  
  # for Tab1 Reactive Map
  observeEvent(input$station, {
    x <- input$station
    if(!is.null(x) && x!=""){
      sink("siteLog.txt", append=TRUE, split=FALSE)
      cat(paste0(x, "\n"))
      sink()
    }
  })
  
  # Make Leaflet Map  
  output$map <- renderLeaflet({
    leaflet() %>%
      setView(-121.75, lat=38.07, zoom = 9) %>%
      addProviderTiles("Esri.WorldImagery", group = "ESRI Aerial") %>%
      addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
      addProviderTiles("OpenStreetMap.BlackAndWhite", group = "OpenBW") %>%
      addProviderTiles("Esri.WorldGrayCanvas", group="ESRI Canvas") %>%
      
      # add scale bar
      addMeasure(position = "topright",
                 primaryLengthUnit = "meters",
                 primaryAreaUnit = "sqmeters",
                 activeColor = "#3D535D",
                 completedColor = "#7D4479") %>%
      
      # add markers
      addCircleMarkers(data=cb_filt_stations, group="Stations",
                       layerId = ~Station,
                       radius = 8, color = "white", fillColor = "purple",
                       weight= 1, fillOpacity=0.7,
                       popup = paste0("Station: ", cb_filt_stations$Station,
                                      "<br> Lon: ", cb_filt_stations$lon,
                                      "<br> Lat: ", cb_filt_stations$lat,
                                      "<br> Type: ", cb_filt_stations$Location,
                                      "<br> YrStart: ", cb_filt_stations$Y_Start,
                                      "<br> YrEnd: ", cb_filt_stations$Y_End)) %>%

      addLayersControl(
        baseGroups = c("ESRI Canvas", "OpenBW",
                       "Topo","ESRI Aerial"),
        overlayGroups = c("Stations"),
        options = layersControlOptions(collapsed = T))
  })
    
  # create a click event for Map
  observeEvent(input$map_marker_click, {
    p <- input$map_marker_click
    if(p$id=="Selected"){
      leafletProxy("map") %>% removeMarker(layerId="Selected")
    } else {
    leafletProxy("map") %>% setView(lng=p$lng, lat=p$lat, input$map_zoom) %>% addCircleMarkers(p$lng, p$lat, radius=10, color="black", fillColor="orange", fillOpacity=1, opacity=1, stroke=TRUE, layerId="Selected")
    }
  })
  
  # make a second event to update future clicks depending on if something has been changed or selected in the se
  observeEvent(input$map_marker_click, {
    p <- input$map_marker_click
    if(!is.null(p$id)){
      if(is.null(input$station)) updateSelectInput(session, "station", selected=p$id)
      if(!is.null(input$station) && input$station!=p$id) updateSelectInput(session, "station", selected=p$id)
    }
  })
  
  observeEvent(input$station, {
    p <- input$map_marker_click
    p2 <- subset(cb_filt_stations, Station==input$station)
    if(nrow(p2)==0){
      leafletProxy("map") %>% removeMarker(layerId="Selected")
    } else if(is.null(p$id) || input$station!=p$id){
      leafletProxy("map") %>% setView(lng=p2$lon, lat=p2$lat, input$map_zoom) %>% addCircleMarkers(p2$lon, p2$lat, radius=10, color="black", fillColor="orange", fillOpacity=1, opacity=1, stroke=TRUE, layerId="Selected")
    }
  })
  

  # Tab1: plot date range of available data for station
  output$plotRange <- renderPlot({
    
    p1 <- ggplot() + 
      geom_linerange(data=cb_filt, aes(x=Station, ymin=minDate, ymax=maxDate), color="gray50", alpha=0.6) +
      geom_linerange(data=datasetInput(), aes(x=Station, ymin=minDate, ymax=maxDate), color="orange", lwd=1.5) + 
      coord_flip() +
      scale_y_date(date_breaks = "3 years",date_labels = "%Y", 
                   limits = c(as.Date("1972-01-10", "%Y-%m-%d"), 
                              as.Date("2018-01-01", "%Y-%m-%d")))

    print(p1)
  })

  # Tab2: Select columns
  df_sel <- reactive({
    switch(input$variables,
           cb_filt %>% select(Year, Survey, Date, Station:Temperature, input$variables) %>% 
             dplyr::filter(Year %in% input$yr_range, Survey %in% input$mon_range, input$variables>0) %>% 
             mutate(Year = as.factor(Year), Survey=as.factor(Survey))
    )
  })
  
  output$plotData <- renderPlot({
    plot2 <- ggplot(df_sel(), aes_string(x="Survey", y=input$variables, fill="Year")) + 
      geom_boxplot(position=position_dodge(width=1))
      scale_fill_viridis_d()
    
    if (input$logscale)
      plot2 <- plot2 + scale_y_log10()

    facets <- paste(input$facet_row, '~', input$facet_col)
    if (facets != '. ~ .')
      plot2 <- plot2 + facet_grid(facets, scales = "free")
    
    print(plot2)
    
  })
  
  output$map2 <- renderPlot({
    ggplot() + geom_sf(data=df_sel(), pch=21, fill="orange") + 
    theme_light()
  })
  
  
})

