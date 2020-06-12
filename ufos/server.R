shinyServer(function(input, output) {
  
  output$dt1 <- DT::renderDataTable({
    ufos

  }) 
  
  output$percentbyyear_shape <- renderPlot({
    ufos %>%
      group_by(.,year, shape) %>%
      summarise(.,Count = n()) %>%
      mutate(., percentage = Count/sum(Count)) %>%
      mutate(., shape = toupper(shape)) %>%
      filter(., shape == input$craftshape) %>%
      ggplot(data = ., aes( x = year, y = percentage)) + geom_smooth() + 
      ggtitle("Relative Frequency of UFO Shape Over years") + ylab("Percentage of UFO Shape") +
      xlab("Year") + xlim(1949, 2014) + ylim(0, .35)
    
  })
  
  output$appearance <- renderPlot({
    ufos %>%
      filter(., year == input$year_sighting) %>%
      mutate(., duration.seconds = as.numeric(duration.seconds)) %>%
      group_by(., year, datetime) %>%
      summarise(., sum_of_encounters = sum(duration.seconds)/60) %>%
      mutate(., date = parse_date_time(datetime, orders = c("mdy"))) %>%
      select(., date, sum_of_encounters) %>%
      calendarPlot(., pollutant = "sum_of_encounters", year = input$year_sighting,
                   main = "Minute-sum of Sightings by Day")
    
  })
  
  output$ufomap <- renderPlot({
    g + ufos %>% filter(., year == input$year_sighting_map) %>% geom_point(
      data = .,
      aes(x = longitude, y = latitude),
      color = "red",
      alpha = 0.25
    )
    
  })
  
  output$duration_year <- renderPlot({
    ufos %>%
      mutate(duration.seconds = as.numeric(duration.seconds)) %>%
      group_by(., year) %>%
      summarise(., average_duration = mean(duration.seconds)/60) %>%
      filter(., average_duration != is.na(average_duration)) %>%
      ggplot(data = ., aes(x = year, y = average_duration)) + geom_point() + ylim(0,480) +
      ggtitle("Average Encounter Duration") + ylab("Time in Minutes") +
      xlab("Year") 
    
  })

  

})
